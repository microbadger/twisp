defmodule Twisp do
  use Application

  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.info "Listening on http://0.0.0.0:4000"

    children = [
      supervisor(Twisp.RecorderSupervisor, []),
      Plug.Adapters.Cowboy.child_spec(:http, Twisp.Router, [], [port: 4000])
    ]

    opts = [strategy: :one_for_one, name: Twisp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
