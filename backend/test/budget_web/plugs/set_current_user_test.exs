defmodule BudgetWeb.Plugs.SetCurrentUserTest do
  use BudgetWeb.ConnCase
  alias BudgetWeb.AuthToken
  alias BudgetWeb.Plugs.SetCurrentUser

  test "setting the user to current user" do
    user_attrs = %{
      email: "test@example.com",
      password: "hunter2"
    }

    {:ok, user} = Budget.Accounts.create_user(user_attrs)

    session = AuthToken.sign(user)

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> SetCurrentUser.call(%{})

    assert user == conn.private.absinthe.context.current_user
  end

  test "setting the user to current user when an invalid authorization is passed" do
    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer hi")
      |> SetCurrentUser.call(%{})

    assert %{} == conn.private.absinthe.context
  end

  test "setting the user to current user when no authorization is passed" do
    conn =
      build_conn()
      |> SetCurrentUser.call(%{})

    assert %{} == conn.private.absinthe.context
  end
end
