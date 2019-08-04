defmodule BudgetWeb.Router do
  use BudgetWeb, :router
  @dialyzer {:nowarn_function, __checks__: 0}

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: BudgetWeb.Schema.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BudgetWeb.Schema.Schema,
      socket: BudgetWeb.UserSocket,
      interface: :simple
  end
end
