defmodule BudgetSH.Repo do
  use Ecto.Repo,
    otp_app: :budgetsh,
    adapter: Ecto.Adapters.Postgres
end
