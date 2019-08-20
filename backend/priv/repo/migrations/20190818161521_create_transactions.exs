defmodule Budgetsh.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :public_id, :uuid
      add :amount, :string
      add :currency_code, :string
      add :tags, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing)
      add :linked_transaction_id, references(:transactions, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)
      add :transaction_date, :date

      timestamps()
    end

    create index(:transactions, [:user_id])
    create index(:transactions, [:linked_transaction_id])
    create index(:transactions, [:account_id])
    create index(:transactions, [:public_id])
  end
end
