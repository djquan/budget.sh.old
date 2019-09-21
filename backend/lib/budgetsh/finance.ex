defmodule BudgetSH.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false

  alias BudgetSH.Repo
  alias BudgetSH.Finance.Account
  alias BudgetSH.Finance.Transaction
  alias BudgetSH.Accounts.User

  alias Ecto.Changeset

  @spec list_accounts(%User{}) :: [%Account{}]
  def list_accounts(user) do
    user
    |> Account.user_scoped()
    |> Repo.all()
  end

  @doc """
  Gets a single account by id

  Raises `Ecto.NoResultsError` if the Account does not exist.
  """
  @spec get_account!(binary, %User{}) :: %Account{}
  def get_account!(id, user) do
    user
    |> Account.user_scoped()
    |> Repo.get_by!(id: id)
  end

  @doc """
  Creates a account.
  """
  @spec create_account(%{}, %User{}) :: {:ok, %Account{}} | {:error, %Changeset{}}
  def create_account(attrs \\ %{}, user) do
    %Account{}
    |> Account.changeset(attrs)
    |> Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a account.
  """
  @spec update_account(%Account{}, %{}) :: {:ok, %Account{}} | {:error, %Changeset{}}
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.
  """
  @spec delete_account(%Account{}) :: {:ok, %Account{}} | {:error, %Changeset{}}
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Creates a transaction
  """
  @spec create_transaction(%{}, %Account{}) :: {:ok, %Transaction{}} | {:error, %Changeset{}}
  def create_transaction(attrs \\ %{}, account, linked_transactions \\ []) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Changeset.put_assoc(:account, account)
    |> link_transactions(linked_transactions)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction
  """
  @spec update_transaction(%Transaction{}, %{}) :: %Transaction{}
  def update_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Lists transactions scoped to Accounts
  """
  @spec list_transactions(%Account{}) :: [%Account{}]
  def list_transactions(account) do
    account
    |> Transaction.account_scoped()
    |> Repo.all()
  end

  @doc """
  Returns a transaction
  """
  @spec get_transaction!(binary, %Account{}) :: %Transaction{}
  def get_transaction!(id, account) do
    account
    |> Transaction.account_scoped()
    |> Repo.get_by!(id: id)
  end

  @doc """
  Deletes a transaction
  """
  @spec delete_transaction(%Transaction{}) :: {:ok, %Transaction{}} | {:error, %Changeset{}}
  def delete_transaction(transaction) do
    Repo.delete(transaction)
  end

  defp link_transactions(changeset, transactions = [_]) do
    if Changeset.get_change(changeset, :type) == :credit do
      changeset
      |> Changeset.put_assoc(
        :debits,
        Enum.filter(transactions, fn txn -> txn.type == :debit end)
      )
    else
      changeset
      |> Changeset.put_assoc(
        :credits,
        Enum.filter(transactions, fn txn -> txn.type == :credit end)
      )
    end
  end

  defp link_transactions(changeset, []), do: changeset
end
