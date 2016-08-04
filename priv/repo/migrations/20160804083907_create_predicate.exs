defmodule Twisp.Repo.Migrations.CreatePredicate do
  use Ecto.Migration

  def change do
    create table(:predicates) do
      add :key, :string
      add :values, {:array, :string}

      timestamps()
    end
    create unique_index(:predicates, [:key])

  end
end
