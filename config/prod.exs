use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :twisp, Twisp.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "example.org", port: 80],
  cache_static_manifest: "priv/static/manifest.json"

# Do not print debug messages in production
config :logger, level: :info

config :twisp, Twisp.Endpoint,
  secret_key_base: {:system, "SECRET_KEY_BASE"}

config :twisp, Twisp.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  pool_size: 20

config :extwitter, :oauth, [
   consumer_key:        {:system, "TWITTER_CONSUMER_KEY"},
   consumer_secret:     {:system, "TWITTER_CONSUMER_SECRET"},
   access_token:        {:system, "TWITTER_ACCESS_TOKEN"},
   access_token_secret: {:system, "TWITTER_ACCESS_TOKEN_SECRET"}
]
