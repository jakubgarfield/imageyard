defmodule Imageyard.Repo.Migrations.CreatePhoto do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :set, :string
      add :name, :string
      add :container, :string
      add :dimensions, {:array, :string}
      add :storage_id, :integer

      timestamps
    end
    create index(:photos, [:storage_id])

  end
end
