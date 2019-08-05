defmodule BudgetSHWeb.Resolvers.Accounts do
  alias BudgetSH.Accounts
  alias BudgetSHWeb.Schema
  alias BudgetSHWeb.AuthToken
  alias BudgetSHWeb.Schema.ChangesetErrors

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end

  def signup(_, args, _) do
    case Accounts.create_user(args) do
      {:error, changeset} ->
        {
          :error,
          message: "Could not create account", details: ChangesetErrors.error_details(changeset)
        }

      {:ok, user} ->
        {:ok, %{session: AuthToken.sign(user), user: user}}
    end
  end

  def signin(_, %{email: email, password: password}, _) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        {:ok, %{session: AuthToken.sign(user), user: user}}

      {:error, _} ->
        {:error, "Invalid username or password"}
    end
  end
end
