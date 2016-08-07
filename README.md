![Twisp](http://i.imgbox.com/52TO2ziT.png)

[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/maxmouchet/twisp/blob/master/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/maxmouchet/twisp.svg?maxAge=2592000&style=flat-square)](https://hub.docker.com/r/maxmouchet/twisp/)
[![Travis](https://img.shields.io/travis/maxmouchet/twisp.svg?maxAge=2592000&style=flat-square)](https://travis-ci.org/maxmouchet/twisp)


Twisp follows specified keywords and users using Twitter streaming API, and save matching tweets as JSON in PgSQL.

## Usage

```bash
curl -X "POST" "http://127.0.0.1:4000/recorders" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d "{'database_url': 'postgres://user:password@host:5432/tweets_db',
          'twitter_consumer_key':        '...',
          'twitter_consumer_secret':     '...',
          'twitter_access_token':        '...',
          'twitter_access_token_secret': '...',
          'keywords': ['#pokemon',':)']}"
```

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
```
