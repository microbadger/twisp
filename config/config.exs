use Mix.Config

config :twisp, http: [port: 4000]

# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
import_config "#{Mix.env}.exs"
