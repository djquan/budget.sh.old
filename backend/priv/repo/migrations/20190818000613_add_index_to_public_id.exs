defmodule BudgetSH.Repo.Migrations.AddIndexToPublicId do
  use Ecto.Migration

  def change do
    create index(:accounts, [:public_id])
  end
end
