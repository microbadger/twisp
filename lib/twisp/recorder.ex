defmodule Twisp.Recorder do
  use GenServer

  require Logger

  alias Twisp.{Repo, Predicate, Tweet}

  import Ecto.Query, only: [from: 2]

  # TODO: Add language option
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    send(self(), :work)
    {:ok, state}
  end

  def handle_info(:work, state) do
    track_list  = fetch_predicate("track")
    follow_list = fetch_predicate("follow")

    Logger.info("Starting Twitter stream")    
    Logger.info("track_list=#{track_list};follow_list=#{follow_list}")    

    ExTwitter.stream_filter(track: track_list, follow: follow_list, language: "en")
      |> Stream.map(fn(x) -> Map.from_struct(x) end)    
      |> Stream.map(fn(x) -> %Tweet{data: x} end)    
      |> Stream.map(fn(x) -> Repo.insert(x) end)    
      |> Enum.to_list
    
    {:noreply, state}
  end

  defp fetch_predicate(key) do
    Repo.all(from p in Predicate, where: p.key == ^key)
      |> Enum.map(fn(p) -> Enum.join(p.values, ",") end)
      |> Enum.at(0, "")
  end

end
