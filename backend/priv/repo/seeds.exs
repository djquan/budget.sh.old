# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BudgetSH.Repo.insert!(%BudgetSH.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BudgetSH.Finance

{:ok, user} =
  %{password: "hunter2", email: "test@budget.sh"}
  |> BudgetSH.Accounts.create_user()

{:ok, _} =
  %{name: "Test Account 1"}
  |> Finance.create_account(user)

{:ok, account} =
  %{name: "Test Account 2"}
  |> Finance.create_account(user)

{:ok, transaction} =
  %{
    amount: "100",
    currency_code: "USD",
    transaction_date: Date.utc_today(),
    tags: ["apple"],
    type: :credit
  }
  |> Finance.create_transaction(account)
