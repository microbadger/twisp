defmodule Twisp.Router do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Poison
  plug :match
  plug :dispatch

  get "/" do
    # TODO: Add parameters and description
    # Use introspection ?
    # data = %{"routes" => [
    #     %{"method" => "GET",
    #       "path"   => "/status"},
    #     %{"method" => "POST",
    #       "path"   => "/recorders"}
    #   ]}
    data = %{}
    send_json(conn, 200, data)
  end

  get "/recorders" do
    statuses = Supervisor.which_children(Twisp.RecorderSupervisor)
    |> Enum.map(fn(x) -> Tuple.to_list(x) |> Enum.at(1) end)
    |> Enum.map(fn(x) -> Twisp.Recorder.get_status(x) end)

    send_json(conn, 200, %{recorders: statuses})
  end

  post "/recorders" do
    {conn, params} = {conn, %{}}
    |> unwrap_param("database_url")
    |> unwrap_param("twitter_consumer_key")
    |> unwrap_param("twitter_consumer_secret")
    |> unwrap_param("twitter_access_token")
    |> unwrap_param("twitter_access_token_secret")
    |> unwrap_param("keywords", false)
    |> unwrap_param("user_ids", false)

    {:ok, pid} = Supervisor.start_child(Twisp.RecorderSupervisor, [params])
    status = Twisp.Recorder.get_status(pid)

    send_json(conn, 200, %{status: status})
  end

  delete "/recorders/:id" do
    pid = String.to_char_list("<#{id}>") |> :erlang.list_to_pid
    # TODO: Proper shutdown
    Supervisor.terminate_child(Twisp.RecorderSupervisor, pid)
    send_json(conn, 204, %{})
  end

  match _ do
    send_json(conn, 404, %{help: "GET / for routes description"})
  end

  defp send_json(conn, status_code, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, Poison.encode!(data))
  end

  defp unwrap_param({conn, acc}, key, is_required \\ true) do
    case Map.get(conn.params, key) do
      nil when is_required ->
        conn = send_json(conn, 401, %{missing_key: key})
        {conn, acc}
      nil when not is_required ->
        {conn, acc}
      res ->
        {conn, Map.put(acc, String.to_atom(key), res)}
    end
  end

end
