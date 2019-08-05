use Mix.Config

host = if System.get_env("CI") == "true", do: "budgetsh_test_postgres", else: "localhost"

config :budgetsh, BudgetSH.Repo,
  username: "postgres",
  password: "postgres",
  database: "budgetsh_test",
  hostname: host,
  pool: Ecto.Adapters.SQL.Sandbox

config :budgetsh, BudgetSHWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :budgetsh, :sessions, salt: "test salt"
