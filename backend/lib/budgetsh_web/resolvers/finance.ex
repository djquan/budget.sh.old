defmodule BudgetSHWeb.Resolvers.Finance do
  alias BudgetSH.Finance
  alias BudgetSH.Finance.Transaction
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

  @spec list_accounts(any, %{}, %{context: %{current_user: map}}) ::
          {:ok, [%{name: binary, public_id: binary}]}
  def list_accounts(_, args, %{context: %{current_user: user}}) do
    accounts =
      Finance.list_accounts(user)
      |> Enum.reject(fn account -> args[:user_accounts] && !account.user_account end)
      |> Enum.map(fn account -> %{name: account.name, public_id: account.public_id} end)

    {:ok, accounts}
  end

  @spec create_transactions(any, %{transactions: [%{account_id: binary}]}, %{
          context: %{current_user: %User{}}
        }) ::
          {:ok, [%Transaction{}]}
  def create_transactions(_, %{transactions: args}, %{context: %{current_user: user}}) do
    transactions =
      for arg <- args do
        {account_id, arg} = Map.pop(arg, :account_id)

        with account <- Finance.get_account!(account_id, user),
             {:ok, transaction} <- Finance.create_transaction(arg, account) do
          transaction
        end
      end

    {:ok, transactions}
  end
end
