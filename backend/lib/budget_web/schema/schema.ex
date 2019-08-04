defmodule BudgetWeb.Schema.Schema do
  use Absinthe.Schema
  alias Budget.Resolvers
  import_types(Absinthe.Type.Custom)

  query do
    @desc "Get info on the currently logged in user"
    field :me, :user do
      resolve(&Resolvers.Accounts.me/3)
    end
  end

  object :user do
    field :email, non_null(:string)
  end

  def context(ctx), do: ctx
end
