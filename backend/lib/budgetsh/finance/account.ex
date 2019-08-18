defmodule BudgetSH.Finance.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias BudgetSH.Accounts.User
  alias BudgetSH.Finance.Account

  schema "accounts" do
    field :name, :string
    field :public_id, :binary_id
    belongs_to :user, BudgetSH.Accounts.User
    timestamps()
  end

  @spec changeset(%Account{}, %{}) :: Ecto.Changeset.t()
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name])
    |> put_public_id_if_not_present
    |> validate_required([:name])
    |> unique_constraint(:user_id)
  end

  @spec user_scoped(%User{}) :: Ecto.Query.t()
  def user_scoped(user) do
    from(a in __MODULE__, where: a.user_id == ^user.id)
  end

  @spec put_public_id_if_not_present(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp put_public_id_if_not_present(changeset) do
    changeset
    |> put_change(:public_id, get_field(changeset, :public_id, Ecto.UUID.generate()))
  end
end
