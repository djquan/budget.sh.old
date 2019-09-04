defmodule BudgetSH.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      BudgetSH.Repo,
      BudgetSHWeb.Endpoint,
      {Cluster.Supervisor, [Application.get_env(:libcluster, :topologies)]}
    ]

    opts = [strategy: :one_for_one, name: BudgetSH.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec config_change(any, any, any) :: :ok
  def config_change(changed, _new, removed) do
    BudgetSHWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
