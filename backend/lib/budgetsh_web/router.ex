defmodule BudgetSHWeb.Router do
  use BudgetSHWeb, :router
  @dialyzer {:nowarn_function, __checks__: 0}

  pipeline :api do
    plug :accepts, ["json"]
    plug BudgetSHWeb.Plugs.SetCurrentUser
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: BudgetSHWeb.Schema.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BudgetSHWeb.Schema.Schema,
      socket: BudgetSHWeb.UserSocket
  end
end
