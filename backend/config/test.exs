use Mix.Config

config :budget, Budget.Repo,
  username: "postgres",
  password: "postgres",
  database: "budget_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :budget, BudgetWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
