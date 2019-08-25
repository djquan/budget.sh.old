defmodule BudgetSH.Repo.Migrations.RemoveUniqueIndexForAccounts do
  use Ecto.Migration

  def change do
    drop unique_index(:accounts, [:user_id])
  end
end
