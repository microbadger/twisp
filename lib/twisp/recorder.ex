defmodule Twisp.Recorder do
  use GenServer

  require Logger

  @create_tweets_sql """
    CREATE TABLE IF NOT EXISTS "tweets" (
      "id"          serial,
      "data"        jsonb     NOT NULL,
      "inserted_at" timestamp NOT NULL DEFAULT localtimestamp,
      PRIMARY KEY ("id")
    );
  """

  def start_link(params, opts \\ []) do
     GenServer.start_link(__MODULE__, %{params: params, tweet_count: 0}, opts)
  end

  def get_status(pid) do
    GenServer.call(pid, :get_status)
  end

  def tweet_recorded(pid) do
    GenServer.cast(pid, :tweet_received)
  end

  def init(state) do
    {:ok, pg_pid} = link_db(state.params.database_url)

    Logger.info "Creating table `tweets` if not exists"
    Postgrex.query!(pg_pid, @create_tweets_sql, [])

    keywords = Map.get(state.params, :keywords, []) |> Enum.join(",")
    user_ids = Map.get(state.params, :user_ids, []) |> Enum.join(",")
    language = Map.get(state.params, :language, "en")

    oauth_tokens = [consumer_key:        state.params.twitter_consumer_key,
                    consumer_secret:     state.params.twitter_consumer_secret,
                    access_token:        state.params.twitter_access_token,
                    access_token_secret: state.params.twitter_access_token_secret]

    current_pid = self()
    spawn_monitor(fn ->
      Logger.info("Starting Twitter stream")
      Logger.info("Language: #{language} / Keywords: #{keywords} / User IDs: #{user_ids}")

      ExTwitter.configure(:process, oauth_tokens)

      ExTwitter.stream_filter(track: keywords, follow: user_ids, language: language)
      |> Stream.map(fn(x) -> Map.from_struct(x) end)
      |> Stream.each(fn(_) -> Twisp.Recorder.tweet_recorded(current_pid) end)
      |> Stream.each(fn(x) ->
        Postgrex.query!(pg_pid, "INSERT INTO tweets (data) VALUES ($1)", [x])
      end)
      |> Enum.to_list
    end)

    {:ok, state}
  end

  def handle_call(:get_status, _from, state) do
    params = Map.take(state.params, [:twitter_consumer_key, :twitter_access_token,
                                     :keywords, :user_ids])
    tweet_count = state.tweet_count
    pid = inspect(self)
    {:reply, %{pid: pid, public_params: params, tweet_count: tweet_count}, state}
  end

  def handle_cast(:tweet_received, state) do
    {:noreply, Map.update!(state, :tweet_count, &(&1 + 1))}
  end

  defp parse_database_url(string) do
    uri = URI.parse(string)
    database = String.strip(uri.path, ?/)
    [username, password] = String.split(uri.userinfo, ":", parts: 2)

    %{hostname: uri.host,
      database: database,
      username: username,
      password: password}
  end

  defp link_db(database_url) do
    db_params = parse_database_url(database_url)
    extensions = [{Postgrex.Extensions.JSON, library: Poison}]
    # TODO: Port
    Postgrex.start_link(extensions: extensions,
                        hostname: db_params.hostname,
                        username: db_params.username,
                        password: db_params.password,
                        database: db_params.database)
  end

end
