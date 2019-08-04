defmodule BudgetWeb.Schema.Mutation.SigninTest do
  use BudgetWeb.ConnCase, async: true

  @query """
  mutation signin($email: String!, $password: String!) {
    signin(email: $email, password: $password) {
      user {
        email
      }
      session
    }
  }
  """
  test "signing in" do
    user_attrs = %{
      email: "test@example.com",
      password: "hunter2"
    }

    {:ok, _} = Budget.Accounts.create_user(user_attrs)

    conn =
      post(build_conn(), "/api", %{
        query: @query,
        variables: user_attrs
      })

    assert %{
             "data" => %{
               "signin" => session
             }
           } = json_response(conn, 200)

    assert %{"user" => %{"email" => "test@example.com"}, "session" => session} = session
    assert {:ok, %{id: _}} = BudgetWeb.AuthToken.verify(session)
  end

  test "signing in without the right password" do
    user_attrs = %{
      email: "test@example.com",
      password: "hunter2"
    }

    {:ok, _} = Budget.Accounts.create_user(user_attrs)

    conn =
      post(build_conn(), "/api", %{
        query: @query,
        variables: Map.put(user_attrs, :password, "nope")
      })

    assert %{
             "data" => %{
               "signin" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Invalid username or password",
                 "path" => ["signin"]
               }
             ]
           } = json_response(conn, 200)
  end
end
