defmodule BudgetSHWeb.Schema.Mutation.CreateAccountTest do
  use BudgetSHWeb.ConnCase, async: true
  alias BudgetSH.Finance

  @query """
  mutation createAccount($name: String!) {
    createAccount(name: $name) {
      name
      public_id
      user_account
    }
  }
  """
  @valid_attrs %{password: "some password", email: "username@example.com"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> BudgetSH.Accounts.create_user()

    user
  end

  test "it creates an account" do
    user = user_fixture()
    session = BudgetSHWeb.AuthToken.sign(user)

    input = %{
      name: "Chipotle"
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
               "createAccount" => %{
                 "name" => "Chipotle",
                 "public_id" => public_id,
                 "user_account" => false
               }
             }
           } = json_response(conn, 200)

    assert [account] = Finance.list_accounts(user)
    assert account.public_id == public_id
    assert account.name == "Chipotle"
    assert account.user_account == false
  end

  test "it does not allow creation if not logged in" do
    input = %{
      name: "Chipotle"
    }

    conn =
      build_conn()
      |> post("/", %{
        query: @query,
        variables: input
      })

    assert %{
             "data" => %{
               "createAccount" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Sign in before proceeding",
                 "path" => ["createAccount"]
               }
             ]
           } = json_response(conn, 200)
  end
end
