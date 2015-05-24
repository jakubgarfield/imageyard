defmodule Imageyard.Repo.Migrations.RenamePhotosToImages do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE photos RENAME TO images;"
  end

  def down do
    execute "ALTER TABLE images RENAME TO photos;"
  end
end
