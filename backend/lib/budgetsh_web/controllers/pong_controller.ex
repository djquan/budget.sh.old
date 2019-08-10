defmodule BudgetSHWeb.Controllers.PongController do
  use BudgetSHWeb, :controller

  def index(conn, _params) do
    text(conn, "pong")
  end
end
