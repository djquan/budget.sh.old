defmodule BudgetSHWeb.Schema.Mutation.SignupTest do
  use BudgetSHWeb.ConnCase, async: true

  @query """
  mutation signup($email: String!, $password: String!) {
    signup(email: $email, password: $password) {
      user {
        email
      }
      session
    }
  }
  """
  test "signing up" do
    input = %{
      email: "test@example.com",
      password: "hunter2"
    }

    conn =
      post(build_conn(), "/api", %{
        query: @query,
        variables: input
      })

    assert %{
             "data" => %{
               "signup" => session
             }
           } = json_response(conn, 200)

    assert %{"user" => %{"email" => "test@example.com"}, "session" => session} = session
    assert {:ok, %{id: _}} = BudgetSHWeb.AuthToken.verify(session)
  end

  test "signing up with an invalid password and username" do
    user_attrs = %{
      email: "test",
      password: "hunt"
    }

    conn =
      post(build_conn(), "/api", %{
        query: @query,
        variables: user_attrs
      })

    assert %{
             "data" => %{
               "signup" => nil
             },
             "errors" => [
               %{
                 "details" => %{
                   "email" => ["has invalid format"],
                   "password" => ["should be at least 7 character(s)"]
                 },
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Could not create account",
                 "path" => ["signup"]
               }
             ]
           } = json_response(conn, 200)
  end
end
