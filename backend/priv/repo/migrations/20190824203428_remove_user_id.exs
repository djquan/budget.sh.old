defmodule BudgetSH.Repo.Migrations.RemoveUserId do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      remove :user_id
    end
  end
end
