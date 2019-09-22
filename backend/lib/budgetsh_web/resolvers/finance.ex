defmodule BudgetSHWeb.Resolvers.Finance do
  alias BudgetSH.Finance
  alias BudgetSH.Finance.Account
  alias BudgetSH.Accounts.User
  alias BudgetSHWeb.Schema.ChangesetErrors

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

  @spec create_transactions(any, %{credit: map, debit: map}, %{context: %{current_user: any}}) ::
          any
  def create_transactions(_, %{credit: credit, debit: debit}, %{context: %{current_user: user}}) do
    args = [
      Map.put(credit, :type, :credit),
      Map.put(debit, :type, :debit)
    ]

    with {:ok, transaction} <- Finance.create_transactions(args, user) do
      transaction = transaction |> BudgetSH.Repo.preload([:credits, :debits])

      if transaction.type == :credit do
        {:ok, %{credit: transaction, debit: hd(transaction.debits)}}
      else
        {:ok, %{credit: hd(transaction.credits), debit: transaction}}
      end
    else
      {:error, changeset} ->
        {
          :error,
          message: "Could not create transactions",
          details: ChangesetErrors.error_details(changeset)
        }
    end
  end

  def create_transactions(_, %{credit: credit}, %{context: %{current_user: user}}) do
    args = [Map.put(credit, :type, :credit)]

    with {:ok, transaction} <- Finance.create_transactions(args, user) do
      {:ok, %{credit: transaction}}
    else
      {:error, changeset} ->
        {
          :error,
          message: "Could not create transactions",
          details: ChangesetErrors.error_details(changeset)
        }
    end
  end

  def create_transactions(_, %{debit: debit}, %{context: %{current_user: user}}) do
    args = [Map.put(debit, :type, :debit)]

    with {:ok, transaction} <- Finance.create_transactions(args, user) do
      {:ok, %{debit: transaction}}
    else
      {:error, changeset} ->
        {
          :error,
          message: "Could not create transactions",
          details: ChangesetErrors.error_details(changeset)
        }
    end
  end
end
