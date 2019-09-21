defmodule BudgetSHWeb.Schema.Schema do
  use Absinthe.Schema
  alias BudgetSHWeb.Resolvers
  alias BudgetSH.Finance
  alias BudgetSHWeb.Schema.Middleware
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]
  import_types(Absinthe.Type.Custom)

  query do
    @desc "Get info on the currently logged in user"
    field :me, :user do
      resolve(&Resolvers.Accounts.me/3)
    end

    @desc "Lists accounts"
    field :list_accounts, list_of(:account) do
      arg(:user_accounts, :boolean)
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Finance.list_accounts/3)
    end

    @desc "Get Account"
    field :get_account, :account do
      arg(:id, non_null(:string))
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Finance.get_account/3)
    end
  end

  mutation do
    @desc "Create a user account"
    field :signup, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.signup/3)
    end

    @desc "Sign in user account"
    field :signin, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.signin/3)
    end

    @desc "Create an account"
    field :create_account, :account do
      arg(:name, non_null(:string))
      arg(:user_account, :boolean)
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Finance.create_account/3)
    end

    @desc
    field :create_transactions, :transaction do
      arg(:transactions, list_of(:transaction_input))
      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Finance.create_transactions/3)
    end
  end

  enum :transaction_type do
    value(:credit)
    value(:debit)
  end

  input_object :transaction_input do
    field :account_id, non_null(:string)
    field :transaction_date, non_null(:date)
    field :amount, non_null(:string)
    field :currency_code, non_null(:string)
    field :tags, list_of(:string)
    field :type, non_null(:transaction_type)
  end

  object :transaction do
    field :id, non_null(:string)
    field :amount, non_null(:string)
    field :currency_code, non_null(:string)
    field :type, non_null(:transaction_type)
    field :transaction_date, non_null(:date)
    field :credits, list_of(:transaction), resolve: dataloader(Finance)
    field :debits, list_of(:transaction), resolve: dataloader(Finance)
  end

  object :user do
    field :email, non_null(:string)
  end

  object :session do
    field :user, non_null(:user)
    field :session, non_null(:string)
  end

  object :account do
    field :id, non_null(:string)
    field :name, non_null(:string)
    field :user_account, non_null(:boolean)

    field :transactions, list_of(:transaction) do
      arg(:limit, type: :integer, default_value: 100)
      resolve(dataloader(Finance, :transactions, args: %{}))
    end
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Finance, Finance.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
