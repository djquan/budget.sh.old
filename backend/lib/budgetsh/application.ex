defmodule BudgetSH.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BudgetSH.Repo,
      BudgetSHWeb.Endpoint
      # Starts a worker by calling: BudgetSH.Worker.start_link(arg)
      # {BudgetSH.Worker, arg},
    ]

    opts = [strategy: :one_for_one, name: BudgetSH.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BudgetSHWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
