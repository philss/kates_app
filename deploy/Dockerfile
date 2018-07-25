FROM elixir:1.6.4-alpine as builder

ARG APP_NAME=kates_app
ENV MIX_ENV=prod REPLACE_OS_VARS=true

RUN apk add --update alpine-sdk coreutils curl

RUN mix local.hex --force \
  && mix local.rebar --force

WORKDIR /opt/app
COPY . /opt/app

RUN mix deps.get && \
    mix release --env=prod --verbose
RUN mkdir -p /opt && \
    mv /opt/app/_build/prod/rel/${APP_NAME} /opt/release

FROM alpine:3.7

ARG REVISION
ENV MIX_ENV=prod PORT=4000 REPLACE_OS_VARS=true APP_REVISION=$REVISION

RUN apk update && apk --no-cache --update add bash curl openssl-dev postgresql-client

WORKDIR /opt/app
EXPOSE ${PORT}
COPY --from=builder /opt/release .
CMD /opt/app/bin/kates_app foreground
