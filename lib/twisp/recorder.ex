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
    GenServer.cast(pid, :tweet_recorded)
  end

  def init(state) do
    {:ok, db_pid} = Twisp.Database.start_link(url: state.params.database_url)

    Logger.info "Creating table `tweets` if not exists"
    Twisp.Database.query!(db_pid, @create_tweets_sql)

    keywords = Map.get(state.params, :keywords, []) |> Enum.join(",")
    user_ids = Map.get(state.params, :user_ids, []) |> Enum.join(",")
    language = Map.get(state.params, :language, "en")

    oauth_tokens = [consumer_key:        state.params.twitter_consumer_key,
                    consumer_secret:     state.params.twitter_consumer_secret,
                    access_token:        state.params.twitter_access_token,
                    access_token_secret: state.params.twitter_access_token_secret]

    current_pid = self()
    spawn_monitor(fn ->
      Logger.info "Starting Twitter stream"
      Logger.info "Language: #{language} / Keywords: #{keywords} / User IDs: #{user_ids}"

      ExTwitter.configure(:process, oauth_tokens)

      ExTwitter.stream_filter(track: keywords, follow: user_ids, language: language)
      |> Stream.map(fn(x)  -> Map.from_struct(x) end)
      |> Stream.each(fn(x) ->
        case Twisp.Database.query(db_pid, "INSERT INTO tweets (data) VALUES ($1)", [x]) do
          {:error, error} ->
            Logger.error "Error #{inspect(error)} while inserting tweet #{inspect(x)}"
          {:ok, _} ->
            Twisp.Recorder.tweet_recorded(current_pid)
        end
      end)
      |> Stream.run
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

  def handle_cast(:tweet_recorded, state) do
    {:noreply, Map.update!(state, :tweet_count, &(&1 + 1))}
  end

end
