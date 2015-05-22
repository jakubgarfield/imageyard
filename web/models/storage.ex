defmodule Imageyard.Storage do
  use Imageyard.Web, :model

  schema "storages" do
    field :name, :string
    field :key, :string
    has_many :photos, Imageyard.Photo

    timestamps
  end

  @required_fields ~w(name key)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
