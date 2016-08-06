FROM gliderlabs/alpine:3.4

ENV MIX_ENV prod

ENV RUNTIME_DEPS ca-certificates elixir erlang erlang-crypto erlang-parsetools erlang-syntax-tools erlang-tools
RUN apk --no-cache add $RUNTIME_DEPS && update-ca-certificates

RUN mix local.hex --force && mix local.rebar --force

COPY  . /app
WORKDIR /app

ENV BUILD_DEPS build-base git
RUN apk --no-cache add --virtual build-dependencies $BUILD_DEPS \
  && mix do deps.get --only prod, compile \
  && apk del build-dependencies

EXPOSE 4000
CMD ["mix", "run", "--no-deps-check", "--no-halt"]
