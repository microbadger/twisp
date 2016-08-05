# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Twisp.Repo.insert!(%Twisp.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Twisp.{Repo, Predicate}

Repo.insert! %Predicate{key: "track",  values: ["#pokemon", "#elixir", ":-)"]}
Repo.insert! %Predicate{key: "follow", values: ["44196397", "2916305152"]}
