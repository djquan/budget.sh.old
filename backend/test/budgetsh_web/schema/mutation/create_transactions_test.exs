defmodule BudgetSHWeb.Schema.Mutation.CreateTransactionsTest do
  use BudgetSHWeb.ConnCase, async: true
  alias BudgetSH.Finance

  @query """
  mutation createTransactions($transactions: [TransactionInput]!) {
    createTransactions(transactions: $transactions) {
      id
    }
  }
  """

  def user_fixture() do
    {:ok, user} =
      %{password: "some password", email: "username@example.com"}
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
      transactions: [
        %{
          account_id: visa.id,
          transaction_date: "2019-09-19",
          amount: "1234",
          currency_code: "USD",
          tags: ["burrito"],
          type: "CREDIT"
        },
        %{
          account_id: chipotle.id,
          transaction_date: "2019-09-19",
          amount: "1234",
          currency_code: "USD",
          type: "DEBIT"
        }
      ]
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
                 "id" => id
               }
             }
           } = json_response(conn, 200)

    transaction_1 = Finance.get_transaction!(id, visa) |> BudgetSH.Repo.preload(:debits)

    assert length(transaction_1.debits) == 1
  end

  test "requires login" do
    user = user_fixture()
    visa = account_fixture(user, %{name: "Visa", user_account: true})
    chipotle = account_fixture(user, %{name: "Chiptole"})

    input = %{
      transactions: [
        %{
          account_id: visa.id,
          transaction_date: "2019-09-19",
          amount: "1234",
          currency_code: "USD",
          tags: ["burrito"],
          type: "CREDIT"
        },
        %{
          account_id: chipotle.id,
          transaction_date: "2019-09-19",
          amount: "1234",
          currency_code: "USD",
          type: "DEBIT"
        }
      ]
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
