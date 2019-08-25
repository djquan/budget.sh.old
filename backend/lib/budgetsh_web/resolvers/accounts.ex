defmodule BudgetSHWeb.Resolvers.Accounts do
  alias BudgetSH.Accounts
  alias BudgetSH.Accounts.User
  alias BudgetSHWeb.AuthToken
  alias BudgetSHWeb.Schema.ChangesetErrors

  @spec me(any, any, any) :: {:ok, %User{} | nil}
  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  @spec signup(any, %{}, any) ::
          {:error, [{:details, map} | {:message, <<_::192>>}, ...]}
          | {:ok, %{session: binary, user: %User{}}}
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

  @spec signin(any, %{email: binary, password: binary}, any) ::
          {:error, <<_::224>>} | {:ok, %{session: binary, user: %User{}}}
  def signin(_, %{email: email, password: password}, _) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        {:ok, %{session: AuthToken.sign(user), user: user}}

      {:error, _} ->
        {:error, "Invalid username or password"}
    end
  end
end
