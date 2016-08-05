![Twisp](http://i.imgbox.com/52TO2ziT.png)

Twisp follows specified keywords and users using Twitter streaming API, and save matching tweets as JSON in PgSQL.

## Requirements

- Elixir 1.2+
- Node.js 4.4+
- PostgreSQL 9.3+

## Setup

To obtain Twitter API credentials, first create an [app](https://apps.twitter.com).

```bash
git clone https://github.com/maxmouchet/twisp.git && cd twisp
mix twisp.init # Follow the instructions
mix ecto.setup
```

To run the app at http://localhost:4000:
```bash
mix phoenix.server
```

## Querying Tweets

```sql
# Get all tweets text
SELECT data->>'text' FROM tweets;

# Get everything excepted retweets
SELECT data FROM tweets WHERE data->>'text' NOT LIKE '% RT @%';
```
