# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :budgetsh, BudgetSH.Repo,
  username: System.get_env("POSTGRES_PRODUCTION_USERNAME", "postgres"),
  password: System.get_env("POSTGRES_PRODUCTION_PASSWORD", "postgres"),
  database: "budgetsh_prod",
  hostname: "localhost",
  port: System.get_env("POSTGRES_PORT", "5432"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :budgetsh, BudgetSHWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

session_salt =
  System.get_env("SESSION_SALT") ||
    raise """
    environment variable SESSION_SALT is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :budgetsh, :sessions, salt: session_salt

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :budgetsh, BudgetSHWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
