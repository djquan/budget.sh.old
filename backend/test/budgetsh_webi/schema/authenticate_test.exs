defmodule BudgetSHWeb.Schema.Middleware.AuthenticateTest do
  use BudgetSHWeb.ConnCase
  alias Absinthe.Resolution
  alias BudgetSHWeb.Schema.Middleware.Authenticate

  test "it proceeds when there is a current user in the context" do
    resolution = %Resolution{context: %{current_user: %BudgetSH.Accounts.User{}}}
    assert resolution == Authenticate.call(resolution, %{})
  end

  test "it does not proceed when there is no current user in the context" do
    resolution = %Resolution{context: %{}}
    assert %Resolution{errors: ["Sign in before proceeding"]} = Authenticate.call(resolution, %{})
  end
end
