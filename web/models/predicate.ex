defmodule Twisp.Predicate do
  use Twisp.Web, :model

  schema "predicates" do
    field :key, :string
    field :values, {:array, :string}

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:key, :values])
    |> validate_required([:key, :values])
    |> unique_constraint(:key)
  end
end
