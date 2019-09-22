defmodule BudgetSHWeb.Schema.Mutation.GetAccountTest do
  use BudgetSHWeb.ConnCase, async: true
  alias BudgetSH.Finance

  @query """
  query getAccount($id: String!) {
    getAccount(id: $id) {
      name
      id
      user_account
    }
  }
  """

  def user_fixture() do
    {:ok, user} =
      %{password: "some password", email: "username@example.com"}
      |> BudgetSH.Accounts.create_user()

    user
  end

  def account_fixture(user) do
    {:ok, account} =
      %{name: "some name"}
      |> Finance.create_account(user)

    account
  end

  def transaction_fixture(account) do
    {:ok, transaction} =
      [
        %{
          amount: "100",
          currency_code: "USD",
          transaction_date: Date.utc_today(),
          tags: ["apple"],
          type: :credit,
          account_id: account.id
        }
      ]
      |> Finance.create_transactions(account.user)

    transaction
  end

  test "getAccount returns an account" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)
    account = account_fixture(user)

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> get("/", query: @query, variables: %{id: account.id})

    assert %{
             "data" => %{
               "getAccount" => %{
                 "name" => "some name",
                 "id" => _,
                 "user_account" => false
               }
             }
           } = json_response(conn, 200)
  end

  test "get Account returns an error if it is not found" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)

    conn =
      conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> get("/", query: @query, variables: %{id: Ecto.UUID.generate()})

    assert %{
             "data" => %{
               "getAccount" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Account does not exist",
                 "path" => ["getAccount"]
               }
             ]
           } = json_response(conn, 200)
  end

  test "getAccount returns an account's transactions" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)
    account = account_fixture(user)
    _transaction = transaction_fixture(account)

    query = """
    query getAccount($id: String!) {
      getAccount(id: $id) {
        name
        id
        user_account
        transactions {
          amount
          id
          type
          account {
            name
          }
          credits {
            id
          }
          debits {
            id
          }
        }
      }
    }
    """

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> get("/", query: query, variables: %{id: account.id})

    assert %{
             "data" => %{
               "getAccount" => %{
                 "name" => "some name",
                 "id" => _,
                 "user_account" => false,
                 "transactions" => [
                   %{
                     "amount" => "100",
                     "id" => _,
                     "account" => %{
                       "name" => "some name"
                     },
                     "type" => "CREDIT",
                     "credits" => [],
                     "debits" => []
                   }
                 ]
               }
             }
           } = json_response(conn, 200)
  end

  test "getAccount returns an error if not signed in" do
    account = account_fixture(user_fixture())
    conn = get build_conn(), "/", query: @query, variables: %{id: account.id}

    assert %{
             "data" => %{
               "getAccount" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Sign in before proceeding",
                 "path" => ["getAccount"]
               }
             ]
           } = json_response(conn, 200)
  end
end
