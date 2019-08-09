defmodule BudgetSH.Finance.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    field :public_id, :binary_id
    belongs_to :user, BudgetSH.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name])
    |> put_change(:public_id, Ecto.UUID.generate())
    |> validate_required([:name])
    |> unique_constraint(:user_id)
  end
end
