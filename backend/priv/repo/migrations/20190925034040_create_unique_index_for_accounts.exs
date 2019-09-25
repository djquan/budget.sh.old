defmodule BudgetSH.Repo.Migrations.CreateUniqueIndexForAccounts do
  use Ecto.Migration

  def change do
    create unique_index(:accounts, [:name, :user_id], name: :user_account_name_unique_index)
  end
end
