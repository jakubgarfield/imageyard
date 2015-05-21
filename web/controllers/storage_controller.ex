defmodule Imageyard.StorageController do
  use Imageyard.Web, :controller

  alias Imageyard.Storage

  plug :scrub_params, "storage" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    storages = Repo.all(Storage)
    render(conn, "index.html", storages: storages)
  end

  def new(conn, _params) do
    changeset = Storage.changeset(%Storage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"storage" => storage_params}) do
    changeset = Storage.changeset(%Storage{}, storage_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Storage created successfully.")
      |> redirect(to: storage_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    storage = Repo.get(Storage, id)
    render(conn, "show.html", storage: storage)
  end

  def edit(conn, %{"id" => id}) do
    storage = Repo.get(Storage, id)
    changeset = Storage.changeset(storage)
    render(conn, "edit.html", storage: storage, changeset: changeset)
  end

  def update(conn, %{"id" => id, "storage" => storage_params}) do
    storage = Repo.get(Storage, id)
    changeset = Storage.changeset(storage, storage_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Storage updated successfully.")
      |> redirect(to: storage_path(conn, :index))
    else
      render(conn, "edit.html", storage: storage, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    storage = Repo.get(Storage, id)
    Repo.delete(storage)

    conn
    |> put_flash(:info, "Storage deleted successfully.")
    |> redirect(to: storage_path(conn, :index))
  end
end
