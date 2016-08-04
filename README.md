# Twisp

## Requirements

- PostgreSQL 9.3+

## Configuration

TODO / Twitter credentials

`mix phoenix.gen.secret`

```elixir
use Mix.Config

config :twisp, Twisp.Endpoint,
  secret_key_base: "SECRET_KEY"

config :twisp, Twisp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "twisp",
  password: "twisp",
  database: "twisp_dev",
  hostname: "localhost",
  pool_size: 20

config :extwitter, :oauth, [
   consumer_key:        "CONSUMER_KEY",
   consumer_secret:     "CONSUMER_SECRET",
   access_token:        "ACCESS_TOKEN",
   access_token_secret: "ACCESS_TOKEN_SECRET"
]
```
