defmodule Imageyard.StorageTest do
  use Imageyard.ModelCase

  alias Imageyard.Storage

  @valid_attrs %{key: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Storage.changeset(%Storage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Storage.changeset(%Storage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
