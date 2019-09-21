defmodule BudgetSHWeb.Schema.Mutation.ListAccountsTest do
  use BudgetSHWeb.ConnCase, async: true
  alias BudgetSH.Finance

  @query """
  {
    listAccounts {
      name
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

  test "listAccounts returns all accounts associated with the signed in user" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)
    _account = account_fixture(user)

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> get("/", query: @query)

    assert %{
             "data" => %{
               "listAccounts" => [
                 %{
                   "name" => "some name"
                 }
               ]
             }
           } = json_response(conn, 200)
  end

  test "list account with user accounts only returns user accounts" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)
    _account = account_fixture(user)
    _user_account = account_fixture(user, %{name: "user", user_account: true})

    query = """
    {
      listAccounts(user_accounts: true) {
        name
      }
    }
    """

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> get("/", query: query)

    assert %{
             "data" => %{
               "listAccounts" => [
                 %{
                   "name" => "user"
                 }
               ]
             }
           } = json_response(conn, 200)
  end

  test "listAccounts returns an error if not signed in" do
    conn = get build_conn(), "/", query: @query

    assert %{
             "data" => %{
               "listAccounts" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Sign in before proceeding",
                 "path" => ["listAccounts"]
               }
             ]
           } = json_response(conn, 200)
  end
end
