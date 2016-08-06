defmodule Twisp.Database do
  @moduledoc """
  Thin wrapper over Postgrex API
  """

  require Logger

  def start_link([url: url]) do
    opts = parse_url(url)
      ++ [extensions: [{Postgrex.Extensions.JSON, library: Poison}]]
    Postgrex.start_link(opts)
  end

  def query!(pid, statement, params \\ [], opts \\ []) do
    Logger.debug("[SQL/#{inspect(pid)}] Executing #{statement}, #{inspect(params)}")
    Postgrex.query!(pid, statement, params, opts)
  end

  # parse_url is from Ecto code
  # https://github.com/elixir-ecto/ecto/blob/master/lib/ecto/repo/supervisor.ex

  defp parse_url(""), do: []

  defp parse_url({:system, env}) when is_binary(env) do
    parse_url(System.get_env(env) || "")
  end

  defp parse_url(url) when is_binary(url) do
    info = url |> URI.decode() |> URI.parse()

    if is_nil(info.host) do
      raise Twisp.Database.InvalidURLError, url: url, message: "host is not present"
    end

    if is_nil(info.path) or not (info.path =~ ~r"^/([^/])+$") do
      raise Twisp.Database.InvalidURLError, url: url, message: "path should be a database name"
    end

    destructure [username, password], info.userinfo && String.split(info.userinfo, ":")
    "/" <> database = info.path

    opts = [username: username,
            password: password,
            database: database,
            hostname: info.host,
            port:     info.port]

    Enum.reject(opts, fn {_k, v} -> is_nil(v) end)
  end

end
