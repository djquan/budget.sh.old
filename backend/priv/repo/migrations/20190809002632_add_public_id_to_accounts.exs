defmodule BudgetSH.Repo.Migrations.AddPublicIdToAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :public_id, :uuid
    end
  end
end
