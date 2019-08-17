FROM reg.quan.io/dan/elixir:1.9 AS build

WORKDIR "/app"
COPY . .

ENV MIX_ENV=prod
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
