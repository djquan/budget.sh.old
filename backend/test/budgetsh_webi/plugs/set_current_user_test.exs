defmodule BudgetSHWeb.Plugs.SetCurrentUserTest do
  use BudgetSHWeb.ConnCase
  alias BudgetSHWeb.AuthToken
  alias BudgetSHWeb.Plugs.SetCurrentUser

  test "setting the user to current user" do
    user_attrs = %{
      email: "test@example.com",
      password: "hunter2"
    }

    {:ok, user} = BudgetSH.Accounts.create_user(user_attrs)

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
