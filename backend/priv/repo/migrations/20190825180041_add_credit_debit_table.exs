defmodule BudgetSH.Repo.Migrations.AddCreditDebitTable do
  use Ecto.Migration

  def change do
    create table(:credit_debit, primary_key: false) do
      add(:debit_id, references(:transactions, on_delete: :delete_all, type: :uuid),
        primary_key: true
      )

      add(:credit_id, references(:transactions, on_delete: :delete_all, type: :uuid),
        primary_key: true
      )
    end

    create index(:credit_debit, [:debit_id])
    create index(:credit_debit, [:credit_id])

    create unique_index(:credit_debit, [:debit_id, :credit_id], name: :credit_debit_unique_id)
  end
end
