defmodule BudgetSH.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  import EctoEnum
  alias BudgetSH.Finance.Transaction
  alias BudgetSH.Finance.Account

  defenum(TransactionTypeEnum, :transaction_type, [:credit, :debit])

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :string
    field :currency_code, :string
    field :tags, {:array, :string}
    field :transaction_date, :date
    field :type, TransactionTypeEnum

    belongs_to :account, BudgetSH.Finance.Account

    many_to_many(:credits, Transaction,
      join_through: "credit_debit",
      join_keys: [credit_id: :id, debit_id: :id]
    )

    many_to_many(:debits, Transaction,
      join_through: "credit_debit",
      join_keys: [debit_id: :id, credit_id: :id]
    )

    timestamps()
  end

  @spec changeset(%Transaction{}, %{id: binary} | %{}) :: Ecto.Changeset.t()
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :currency_code, :tags, :transaction_date, :type, :id, :account_id])
    |> validate_required([:amount, :currency_code, :transaction_date, :type, :account_id])
    |> validate_format(:amount, ~r/^\d+$/, message: "must be numeric")
  end

  @spec account_scoped(%Account{}) :: Ecto.Query.t()
  def account_scoped(account) do
    from(t in __MODULE__, where: t.account_id == ^account.id)
  end

  @spec validate_account_id_not_in(%Ecto.Changeset{}, any) :: %Ecto.Changeset{}
  def validate_account_id_not_in(changeset, missing_account_ids) do
    validate_change(changeset, :account_id, fn :account_id, account_id ->
      case Enum.member?(missing_account_ids, account_id) do
        true -> [account_id: "Could not find account id"]
        false -> []
      end
    end)
  end
end
