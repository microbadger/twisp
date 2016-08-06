defmodule Twisp.RecorderSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: Twisp.RecorderSupervisor])
  end

  def init([]) do
    children = [
      worker(Twisp.Recorder, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
