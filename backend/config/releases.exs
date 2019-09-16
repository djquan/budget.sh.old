import Config

config :budgetsh, BudgetSH.Repo,
  username: "budgetsh",
  password: System.get_env("POSTGRES_PRODUCTION_PASSWORD", "postgres"),
  database: "budgetsh_prod",
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: 25060,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true,
  timeout: 7200_000

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")

config :budgetsh, BudgetSHWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base,
  server: true
