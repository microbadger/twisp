# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :twisp,
  ecto_repos: [Twisp.Repo]

# Configures the endpoint
config :twisp, Twisp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kyjWc1qjC/OUtxBdiEwyaEb49DttLtA/9RZF1TXXsyted9IaVBdrS/iinv5cfhjI",
  render_errors: [view: Twisp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Twisp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
