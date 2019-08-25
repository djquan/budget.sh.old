defmodule BudgetSH.Repo.Migrations.AddTypeToTransaction do
  use Ecto.Migration
  alias BudgetSH.Finance.Transaction.TransactionTypeEnum

  def change do
    TransactionTypeEnum.create_type()

    alter table(:transactions) do
      add(:type, TransactionTypeEnum.type())
    end
  end
end
