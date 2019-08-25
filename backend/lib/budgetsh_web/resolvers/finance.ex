defmodule BudgetSHWeb.Resolvers.Finance do
  alias BudgetSH.Finance
  alias BudgetSH.Accounts.User

  @spec create_account(any, %{}, %{context: %{current_user: %User{}}}) ::
          {:ok, %{name: binary, public_id: binary, user_account: boolean}}
  def create_account(_, args = %{}, %{context: %{current_user: user}}) do
    case Finance.create_account(args, user) do
      {:ok, account} ->
        {:ok,
         %{name: account.name, public_id: account.public_id, user_account: account.user_account}}
    end
  end

  @spec list_accounts(any, any, %{context: %{current_user: map}}) ::
          {:ok, [%{name: binary, public_id: binary}]}
  def list_accounts(_, _, %{context: %{current_user: user}}) do
    accounts =
      Finance.list_accounts(user)
      |> Enum.map(fn account -> %{name: account.name, public_id: account.public_id} end)

    {:ok, accounts}
  end
end
