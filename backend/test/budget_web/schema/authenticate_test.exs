defmodule BudgetWeb.Schema.Middleware.AuthenticateTest do
  use BudgetWeb.ConnCase
  alias Absinthe.Resolution
  alias BudgetWeb.Schema.Middleware.Authenticate

  test "it proceeds when there is a current user in the context" do
    resolution = %Resolution{context: %{current_user: %Budget.Accounts.User{}}}
    assert resolution == Authenticate.call(resolution, %{})
  end

  test "it does not proceed when there is no current user in the context" do
    resolution = %Resolution{context: %{}}
    assert %Resolution{errors: ["Sign in before proceeding"]} = Authenticate.call(resolution, %{})
  end
end
