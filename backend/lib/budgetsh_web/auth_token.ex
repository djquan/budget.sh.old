defmodule BudgetSHWeb.AuthToken do
  alias BudgetSH.Accounts.User

  @doc """
  Encodes the given `user` id and signs it, returning a token
  clients can use as identification when using the API.
  """
  @spec sign(%User{}) :: String.t()
  def sign(user) do
    session_salt = Application.get_env(:budgetsh, :sessions)[:salt]
    Phoenix.Token.sign(BudgetSHWeb.Endpoint, session_salt, %{id: user.id})
  end

  @doc """
  Decodes the original data from the given `token` and
  verifies its integrity.
  """
  @spec verify(String.t()) :: {:ok, %User{}} | {:error, String.t()}
  def verify(token) do
    session_salt = Application.get_env(:budgetsh, :sessions)[:salt]

    Phoenix.Token.verify(BudgetSHWeb.Endpoint, session_salt, token, max_age: 30 * :timer.hours(24))
  end
end
