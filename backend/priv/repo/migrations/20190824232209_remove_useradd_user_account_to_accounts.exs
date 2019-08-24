defmodule BudgetSH.Repo.Migrations.RemoveUseraddUserAccountToAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :user_account, :boolean
    end
  end
end
