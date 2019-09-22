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

  Returns nil if the account does not exist
  """
  @spec get_account(binary, %User{}) :: %Account{} | nil
  def get_account(id, user) do
    user
    |> Account.user_scoped()
    |> Repo.get(id)
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

  def create_transactions(args, user) do
    account_ids =
      args
      |> Enum.map(fn arg ->
        arg.account_id
      end)

    accounts =
      user
      |> Account.user_scoped()
      |> select([a], a.id)
      |> where([a], a.id in ^account_ids)
      |> Repo.all()

    missing_account_ids = account_ids -- accounts

    [changeset | linked_changeset] =
      args
      |> Enum.map(fn arg ->
        %Transaction{}
        |> Transaction.changeset(Map.put(arg, :id, Ecto.UUID.generate()))
        |> Transaction.validate_account_id_not_in(missing_account_ids)
      end)

    changeset
    |> link_transactions(linked_changeset)
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

  # Dataloader

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(Transaction, %{limit: limit}) do
    Transaction
    |> limit(^limit)
  end

  def query(queryable, _) do
    queryable
  end

  defp link_transactions(changeset, linked_changesets = [_]) do
    if Changeset.get_change(changeset, :type) == :credit do
      changeset
      |> Changeset.put_assoc(
        :debits,
        Enum.filter(linked_changesets, fn linked ->
          Changeset.get_change(linked, :type) == :debit
        end)
      )
    else
      changeset
      |> Changeset.put_assoc(
        :credits,
        Enum.filter(linked_changesets, fn linked ->
          Changeset.get_change(linked, :type) == :credit
        end)
      )
    end
  end

  defp link_transactions(changeset, []), do: changeset
end
