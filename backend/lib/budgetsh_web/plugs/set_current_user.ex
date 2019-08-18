defmodule BudgetSHWeb.Plugs.SetCurrentUser do
  @behaviour Plug

  import Plug.Conn
  @type opts :: binary | tuple | atom | integer | float | [opts] | %{opts => opts}

  @spec init(opts) :: opts
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @spec build_context(Plug.Conn.t()) :: %{}
  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, %{id: id}} <- BudgetSHWeb.AuthToken.verify(token),
         %{} = user <- BudgetSH.Accounts.get_user(id) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
