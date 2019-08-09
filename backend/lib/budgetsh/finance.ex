defmodule BudgetSH.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias BudgetSH.Repo

  alias BudgetSH.Finance.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts(user)
      [%Account{}, ...]

  """
  def list_accounts(user) do
    Account.user_scoped(user)
    |> Repo.all()
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123, user)
      %Account{}

      iex> get_account!(456, user)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id, user) do
    Account.user_scoped(user)
    |> Repo.get!(id)
  end

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}, user) do
    %Account{}
    |> Account.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end
end
