defmodule BudgetSH.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)
      add :user_account, :boolean

      timestamps()
    end

    create unique_index(:accounts, [:user_id, :id])
  end
end
