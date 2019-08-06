FROM registry.quan.io/dan/elixir:1.9

WORKDIR "/app"
COPY . .
RUN MIX_ENV=prod mix release
CMD ["_build/prod/rel/budgetsh/bin/budgetsh", "start"]