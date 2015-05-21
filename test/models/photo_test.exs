defmodule Imageyard.PhotoTest do
  use Imageyard.ModelCase

  alias Imageyard.Photo

  @valid_attrs %{container: "some content", dimensions: [], name: "some content", set: "some content", storage: nil}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Photo.changeset(%Photo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Photo.changeset(%Photo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
