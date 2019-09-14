use Mix.Config

config :logger, :console, level: :info

config :cors_plug,
  origin: ["https://budget.sh"],
  max_age: 86400,
  methods: ["GET", "POST"]
