defmodule Twisp do
  use Application

  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:twisp, :http)[:port]
    Logger.info "Listening on http://0.0.0.0:#{port}"

    children = [
      supervisor(Twisp.RecorderSupervisor, []),
      Plug.Adapters.Cowboy.child_spec(:http, Twisp.Router, [], [port: port])
    ]

    opts = [strategy: :one_for_one, name: Twisp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
