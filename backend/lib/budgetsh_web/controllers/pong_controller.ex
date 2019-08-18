defmodule BudgetSHWeb.Controllers.PongController do
  use BudgetSHWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    text(conn, "pong")
  end
end
