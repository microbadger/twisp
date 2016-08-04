defmodule Twisp.PredicateTest do
  use Twisp.ModelCase

  alias Twisp.Predicate

  @valid_attrs %{key: "some content", values: []}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Predicate.changeset(%Predicate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Predicate.changeset(%Predicate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
