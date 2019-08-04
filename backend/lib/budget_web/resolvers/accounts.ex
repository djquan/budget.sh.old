defmodule Budget.Resolvers.Accounts do
  alias Budget.Accounts

  def me(_, _, _) do
    {:ok, %{email: "username@example.com"}}
  end
end
