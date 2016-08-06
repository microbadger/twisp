![Twisp](http://i.imgbox.com/52TO2ziT.png)

Twisp follows specified keywords and users using Twitter streaming API, and save matching tweets as JSON in PgSQL.

## Usage

```bash
# Add -d to run in background
# Add -p XX:4000 to serve the web UI on http://localhost:XX
docker run -e DATABASE_URL="..." \
           -e SECRET_KEY_BASE="..." \
           -e TWITTER_CONSUMER_KEY="..." \
           -e TWITTER_CONSUMER_SECRET="..." \
           -e TWITTER_ACCESS_TOKEN="..." \
           -e TWITTER_ACCESS_TOKEN_SECRET="..." \
           maxmouchet/twisp
```

### Environment

TODO

### Querying Tweets

```sql
# Get all tweets text
SELECT data->>'text' FROM tweets;

# Get everything excepted retweets
SELECT data FROM tweets WHERE data->>'text' NOT LIKE '% RT @%';
```

## Development

### Requirements

- Elixir 1.2+
- Node.js 4.4+
- PostgreSQL 9.3+

### Setup

To obtain Twitter API credentials, first create an [app](https://apps.twitter.com).

```bash
git clone https://github.com/maxmouchet/twisp.git && cd twisp
mix do deps.get, compile
mix twisp.init # Follow the instructions
mix ecto.setup
```

This is a pretty standard Phoenix app, to run the server:
```bash
mix phoenix.server
```
