defmodule Imageyard.Image do
  use Imageyard.Web, :model

  schema "images" do
    field :set, :string
    field :name, :string
    field :container, :string
    field :dimensions, {:array, :string}
    belongs_to :storage, Imageyard.Storage

    timestamps
  end

  @required_fields ~w(set name container dimensions storage_id)
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
