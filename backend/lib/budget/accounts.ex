defmodule Budget.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Budget.Repo

  alias Budget.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @spec list_users :: [%User{}]
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(integer) :: %User{}
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(%{}) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(%User{}, %{}) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(%User{}) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  @spec change_user(%User{}) :: %Ecto.Changeset{}
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Authenticates a user.

  Returns `{:ok, user}` if a user exists with the given username
  and the password is valid. Otherwise, `{:error, reason}` is returned.

  ## Examples
      iex> authenticate("email@example.com", "hunter2222")
      {:ok, %User{}}

      iex> authenticate("email@example.com", "hunter2")
      {:error, "invalid password"}

  """
  @spec authenticate(String.t(), String.t()) :: {:ok, %User{}} | {:error, String.t()}
  def authenticate(email, password) do
    Repo.get_by(User, email: email)
    |> Argon2.check_pass(password)
  end
end
