defmodule Twisp.Repo.Migrations.CreateTweet do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :data, :map

      timestamps()
    end

  end
end
