use Mix.Config

config :budgetsh, BudgetSH.Repo,
  username: System.get_env("POSTGRES_TEST_USERNAME", "postgres"),
  password: System.get_env("POSTGRES_TEST_PASSWORD", "postgres"),
  database: "budgetsh_test",
  hostname: "localhost",
  port: System.get_env("POSTGRES_PORT", "5432"),
  pool: Ecto.Adapters.SQL.Sandbox

config :budgetsh, BudgetSHWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :budgetsh, :sessions, salt: "test salt"
