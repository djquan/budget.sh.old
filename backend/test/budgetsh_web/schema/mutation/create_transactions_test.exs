defmodule BudgetSHWeb.Schema.Mutation.CreateTransactionsTest do
  use BudgetSHWeb.ConnCase, async: true
  alias BudgetSH.Finance

  @query """
  mutation createTransactions($credit: TransactionInput, $debit: TransactionInput) {
    createTransactions(credit: $credit, debit: $debit) {
      credit {
        id
      }
      debit {
        id
      }
    }
  }
  """

  def user_fixture(email \\ "username@example.com") do
    {:ok, user} =
      %{password: "some password", email: email}
      |> BudgetSH.Accounts.create_user()

    user
  end

  def account_fixture(user, attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{name: "some name"})
      |> Finance.create_account(user)

    account
  end

  test "it creates linked transactions" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)
    visa = account_fixture(user, %{name: "Visa", user_account: true})
    chipotle = account_fixture(user, %{name: "Chiptole"})

    input = %{
      credit: %{
        account_id: visa.id,
        transaction_date: "2019-09-19",
        amount: "1234",
        currency_code: "USD",
        tags: ["burrito"]
      },
      debit: %{
        account_id: chipotle.id,
        transaction_date: "2019-09-19",
        amount: "1234",
        currency_code: "USD"
      }
    }

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> post("/", %{
        query: @query,
        variables: input
      })

    assert %{
             "data" => %{
               "createTransactions" => %{
                 "credit" => %{
                   "id" => id
                 },
                 "debit" => %{
                   "id" => id2
                 }
               }
             }
           } = json_response(conn, 200)

    transaction_1 = Finance.get_transaction!(id, visa) |> BudgetSH.Repo.preload(:debits)
    assert length(transaction_1.debits) == 1
    transaction_2 = Finance.get_transaction!(id2, chipotle) |> BudgetSH.Repo.preload(:credits)
    assert length(transaction_2.credits) == 1
  end

  test "can create an unlinked credit" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)
    visa = account_fixture(user, %{name: "Visa", user_account: true})

    input = %{
      credit: %{
        account_id: visa.id,
        transaction_date: "2019-09-19",
        amount: "1234",
        currency_code: "USD",
        tags: ["burrito"]
      }
    }

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> post("/", %{
        query: @query,
        variables: input
      })

    assert %{
             "data" => %{
               "createTransactions" => %{
                 "credit" => %{
                   "id" => id
                 }
               }
             }
           } = json_response(conn, 200)

    transaction_1 = Finance.get_transaction!(id, visa) |> BudgetSH.Repo.preload(:debits)
    assert length(transaction_1.debits) == 0
  end

  test "can create an unlinked debit" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)
    visa = account_fixture(user, %{name: "Visa", user_account: true})

    input = %{
      debit: %{
        account_id: visa.id,
        transaction_date: "2019-09-19",
        amount: "1234",
        currency_code: "USD",
        tags: ["burrito"]
      }
    }

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> post("/", %{
        query: @query,
        variables: input
      })

    assert %{
             "data" => %{
               "createTransactions" => %{
                 "debit" => %{
                   "id" => id
                 }
               }
             }
           } = json_response(conn, 200)

    transaction_1 = Finance.get_transaction!(id, visa) |> BudgetSH.Repo.preload(:credits)
    assert length(transaction_1.credits) == 0
  end

  test "does not let you create a linked transaction for accounts you do not control" do
    wrong_user = user_fixture("wrong_user@example.com")
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)
    visa = account_fixture(wrong_user, %{name: "Visa", user_account: true})
    chipotle = account_fixture(wrong_user, %{name: "Chiptole"})

    input = %{
      credit: %{
        account_id: visa.id,
        transaction_date: "2019-09-19",
        amount: "1234",
        currency_code: "USD",
        tags: ["burrito"]
      },
      debit: %{
        account_id: chipotle.id,
        transaction_date: "2019-09-19",
        amount: "1234",
        currency_code: "USD"
      }
    }

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> post("/", %{
        query: @query,
        variables: input
      })

    assert %{
             "data" => %{
               "createTransactions" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Could not create transactions",
                 "path" => ["createTransactions"],
                 "details" => %{
                   "account_id" => ["Could not find account id"],
                   "debits" => [
                     %{
                       "account_id" => ["Could not find account id"]
                     }
                   ]
                 }
               }
             ]
           } = json_response(conn, 200)
  end

  test "requires login" do
    user = user_fixture()
    visa = account_fixture(user, %{name: "Visa", user_account: true})
    chipotle = account_fixture(user, %{name: "Chiptole"})

    input = %{
      credit: %{
        account_id: visa.id,
        transaction_date: "2019-09-19",
        amount: "1234",
        currency_code: "USD",
        tags: ["burrito"]
      },
      debit: %{
        account_id: chipotle.id,
        transaction_date: "2019-09-19",
        amount: "1234",
        currency_code: "USD"
      }
    }

    conn =
      build_conn()
      |> post("/", %{
        query: @query,
        variables: input
      })

    assert %{
             "data" => %{
               "createTransactions" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Sign in before proceeding",
                 "path" => ["createTransactions"]
               }
             ]
           } = json_response(conn, 200)
  end
end
