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
  %{name: "Test Account 1", user_account: true}
  |> Finance.create_account(user)

{:ok, account} =
  %{name: "Test Account 2", user_account: true}
  |> Finance.create_account(user)

{:ok, chipotle} =
  %{name: "Chipotle", user_account: false}
  |> Finance.create_account(user)

{:ok, _} =
  [
    %{
      amount: "100",
      currency_code: "USD",
      transaction_date: Date.utc_today(),
      tags: ["apple"],
      type: :debit,
      account_id: account.id
    },
    %{
      amount: "100",
      currency_code: "USD",
      transaction_date: Date.utc_today(),
      tags: ["apple"],
      type: :credit,
      account_id: chipotle.id
    }
  ]
  |> Finance.create_transactions()
