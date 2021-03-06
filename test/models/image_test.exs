defmodule Imageyard.ImageTest do
  use Imageyard.ModelCase

  alias Imageyard.Image

  @valid_attrs %{container: "some content", dimensions: [], name: "some content", set: "some content", storage: nil}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Image.changeset(%Image{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Image.changeset(%Image{}, @invalid_attrs)
    refute changeset.valid?
  end
end
