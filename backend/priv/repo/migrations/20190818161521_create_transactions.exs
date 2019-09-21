defmodule Budgetsh.Repo.Migrations.CreateTransactions do
  use Ecto.Migration
  alias BudgetSH.Finance.Transaction.TransactionTypeEnum

  def change do
    TransactionTypeEnum.create_type()

    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :amount, :string
      add :currency_code, :string
      add :tags, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)
      add :linked_transaction_id, references(:transactions, on_delete: :nothing, type: :uuid)
      add :account_id, references(:accounts, on_delete: :nothing, type: :uuid)
      add :transaction_date, :date
      add(:type, TransactionTypeEnum.type())

      timestamps()
    end

    create index(:transactions, [:user_id])
    create index(:transactions, [:linked_transaction_id])
    create index(:transactions, [:account_id])
  end
end
