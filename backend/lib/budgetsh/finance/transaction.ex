defmodule BudgetSH.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  import EctoEnum
  alias BudgetSH.Finance.Transaction
  alias BudgetSH.Finance.Account

  defenum(TransactionTypeEnum, :transaction_type, [:credit, :debit])

  schema "transactions" do
    field :amount, :string
    field :currency_code, :string
    field :public_id, Ecto.UUID
    field :tags, {:array, :string}
    field :linked_transaction_id, :id
    field :transaction_date, :date
    field :type, TransactionTypeEnum

    belongs_to :account, BudgetSH.Finance.Account
    timestamps()
  end

  @spec changeset(%Transaction{}, %{}) :: Ecto.Changeset.t()
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :currency_code, :tags, :transaction_date, :type])
    |> validate_required([:amount, :currency_code, :transaction_date, :type])
    |> validate_format(:amount, ~r/^\d+$/, message: "must be numeric")
  end

  @spec account_scoped(%Account{}) :: Ecto.Query.t()
  def account_scoped(account) do
    from(t in __MODULE__, where: t.account_id == ^account.id)
  end
end
