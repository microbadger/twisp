![Twisp](http://i.imgbox.com/52TO2ziT.png)

Twisp follows specified keywords and users using Twitter streaming API, and save matching tweets as JSON in PgSQL.

## Requirements

- Elixir 1.2+
- PostgreSQL 9.3+

## Setup

```bash
git clone https://github.com/maxmouchet/twisp.git && cd twisp
mix do deps.get, compile
```

### Secrets

You need to create `dev.secret.exs` and `prod.secret.exs` in `config/`. These files contains secrets and are ignored by git.  
To generate `secret_key_base` you may use `mix phoenix.gen.secret`.

```elixir
# config/{env}.secret.exs
use Mix.Config

config :twisp, Twisp.Endpoint,
  secret_key_base: "SECRET_KEY"

config :twisp, Twisp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "DB_USER",
  password: "DB_PASS",
  database: "DB_NAME",
  hostname: "DB_HOST",
  pool_size: 20

config :extwitter, :oauth, [
   consumer_key:        "CONSUMER_KEY",
   consumer_secret:     "CONSUMER_SECRET",
   access_token:        "ACCESS_TOKEN",
   access_token_secret: "ACCESS_TOKEN_SECRET"
]
```
