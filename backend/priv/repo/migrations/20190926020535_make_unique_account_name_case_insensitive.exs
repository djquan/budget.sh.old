defmodule BudgetSH.Repo.Migrations.MakeUniqueAccountNameCaseInsensitive do
  use Ecto.Migration

  def change do
    drop index(:accounts, [:name, :user_id], name: :user_account_name_unique_index)

    create unique_index(:accounts, ["lower(name)", :user_id],
             name: :user_account_name_unique_index
           )
  end
end
