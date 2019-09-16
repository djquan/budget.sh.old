FROM elixir:1.9-alpine
RUN apk add --update build-base npm git bash openssl
RUN mix local.hex --force
RUN mix local.rebar --force
WORKDIR "/app"
COPY . .
ENV MIX_ENV=prod
RUN mix deps.get
RUN mix release --overwrite --force

FROM alpine:3.9 AS app
RUN apk add --update bash openssl
RUN mkdir /app
WORKDIR /app
COPY --from=build /app/_build/prod/rel/budgetsh ./
ENV HOME=/app
RUN chown -R nobody: /app
USER nobody

CMD ["bin/budgetsh", "start"]
