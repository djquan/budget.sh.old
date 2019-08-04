defmodule BudgetWeb.AuthToken do
  @session_salt Application.get_env(:budget, :sessions)[:salt]

  @doc """
  Encodes the given `user` id and signs it, returning a token
  clients can use as identification when using the API.
  """
  def sign(user) do
    Phoenix.Token.sign(BudgetWeb.Endpoint, @session_salt, %{id: user.id})
  end

  @doc """
  Decodes the original data from the given `token` and 
  verifies its integrity.
  """
  def verify(token) do
    Phoenix.Token.verify(BudgetWeb.Endpoint, @session_salt, token, max_age: 30 * :timer.hours(24))
  end
end
