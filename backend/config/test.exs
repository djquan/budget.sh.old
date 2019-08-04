use Mix.Config

host = if System.get_env("CI") == "true", do: "budget_test_postgres", else: "localhost"

config :budget, Budget.Repo,
  username: "postgres",
  password: "postgres",
  database: "budget_test",
  hostname: host,
  pool: Ecto.Adapters.SQL.Sandbox

config :budget, BudgetWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :budget, :sessions, salt: "test salt"
