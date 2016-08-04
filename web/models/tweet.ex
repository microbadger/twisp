defmodule Twisp.Tweet do
  use Twisp.Web, :model

  schema "tweets" do
    field :data, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:data])
    |> validate_required([:data])
  end
end
