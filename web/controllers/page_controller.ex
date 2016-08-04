defmodule Twisp.PageController do
  use Twisp.Web, :controller

  alias Twisp.{Repo, Predicate, Tweet}

  def index(conn, _params) do
    predicates = Repo.all(Predicate)
    tweet_count = Repo.one(from t in Tweet, select: count(t.data))
    render conn, "index.html", predicates: predicates, tweet_count: tweet_count
  end
end
