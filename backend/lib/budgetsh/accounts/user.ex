defmodule BudgetSH.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BudgetSH.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :password_hash, :string
    field :email, :string
    field :password, :string, virtual: true
    has_many :accounts, BudgetSH.Finance.Account
    timestamps()
  end

  @spec changeset(%User{}, %{}) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 7)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  @spec put_pass_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp put_pass_hash(
         %Ecto.Changeset{
           valid?: true,
           changes: %{password: password}
         } = changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
