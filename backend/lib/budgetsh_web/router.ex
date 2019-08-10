defmodule BudgetSHWeb.Router do
  use BudgetSHWeb, :router
  @dialyzer {:nowarn_function, __checks__: 0}

  pipeline :api do
    plug(:accepts, ["json"])
    plug(BudgetSHWeb.Plugs.SetCurrentUser)
  end

  scope "/" do
    pipe_through(:api)
    get("/ping", BudgetSHWeb.Controllers.PongController, :index)

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: BudgetSHWeb.Schema.Schema,
      socket: BudgetSHWeb.UserSocket
    )

    forward("/", Absinthe.Plug, schema: BudgetSHWeb.Schema.Schema)
  end
end
