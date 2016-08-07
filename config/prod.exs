use Mix.Config

config :twisp, http: [port: String.to_integer(System.get_env("PORT") || "4000")]

config :logger, level: :info
