defmodule BudgetSH.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias BudgetSH.Finance.Transaction

  schema "transactions" do
    field :amount, :string
    field :currency_code, :string
    field :public_id, Ecto.UUID
    field :tags, {:array, :string}
    field :linked_transaction_id, :id
    field :transaction_date, :date

    belongs_to :account, BudgetSH.Finance.Account
    timestamps()
  end

  @spec changeset(%Transaction{}, %{}) :: Ecto.Changeset.t()
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :currency_code, :tags, :transaction_date])
    |> put_public_id_if_not_present
    |> validate_required([:amount, :currency_code, :transaction_date])
  end

  @spec put_public_id_if_not_present(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp put_public_id_if_not_present(changeset) do
    changeset
    |> put_change(:public_id, get_field(changeset, :public_id, Ecto.UUID.generate()))
  end
end
