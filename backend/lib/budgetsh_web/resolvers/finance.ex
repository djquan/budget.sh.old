defmodule BudgetSHWeb.Resolvers.Finance do
  alias BudgetSH.Finance
  alias BudgetSH.Finance.Transaction
  alias BudgetSH.Finance.Account
  alias BudgetSH.Accounts.User

  @spec create_account(any, %{}, %{context: %{current_user: %User{}}}) ::
          {:ok, %{name: binary, id: binary, user_account: boolean}}
  def create_account(_, args = %{}, %{context: %{current_user: user}}) do
    case Finance.create_account(args, user) do
      {:ok, account} ->
        {:ok, %{name: account.name, id: account.id, user_account: account.user_account}}
    end
  end

  @spec list_accounts(any, %{}, %{context: %{current_user: map}}) ::
          {:ok, [%{name: binary, id: binary}]}
  def list_accounts(_, args, %{context: %{current_user: user}}) do
    accounts =
      Finance.list_accounts(user)
      |> Enum.reject(fn account -> args[:user_accounts] && !account.user_account end)

    {:ok, accounts}
  end

  @spec get_account(any, nil | keyword | map, %{
          context: %{current_user: %User{}}
        }) :: {:ok, %{name: any, public_id: any, user_account: any}} | {:error, binary}
  def get_account(_, args, %{context: %{current_user: user}}) do
    {:ok, nil}

    case Finance.get_account(args[:id], user) do
      account = %Account{} ->
        {:ok, account}

      nil ->
        {:error, "Account does not exist"}
    end
  end

  @spec create_transactions(any, %{transactions: [%{account_id: binary}]}, %{
          context: %{current_user: %User{}}
        }) ::
          {:ok, [%Transaction{}]}
  def create_transactions(_, %{transactions: args}, %{context: %{current_user: user}}) do
    unknown_accounts =
      Enum.filter(args, fn arg ->
        !Finance.get_account(arg.account_id, user)
      end)
      |> Enum.map(fn arg -> arg.account_id end)

    if length(unknown_accounts) > 0 do
      {:error, "Cannot find account #{Enum.join(unknown_accounts, ",")}"}
    else
      Finance.create_transactions(args)
    end
  end
end
