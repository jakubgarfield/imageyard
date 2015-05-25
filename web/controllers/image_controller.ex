defmodule Imageyard.ImageController do
  use Imageyard.Web, :controller

  alias Imageyard.Image
  alias Imageyard.Storage
  alias Imageyard.ResizeImages
  alias Imageyard.AzureBlob

  plug :scrub_params, "image" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    images = Repo.all(Image) |> Repo.preload([:storage])
    render(conn, "index.html", images: images)
  end

  def new(conn, _params) do
    changeset = Image.changeset(%Image{})
    render(conn, "new.html", changeset: changeset, storages: available_storages)
  end

  def create(conn, %{"image" => image_params}) do
    mapped_parameters = Enum.reduce(image_params, %{}, fn({k,v}, map) ->
      Map.put(map, k, transform_parameters(k, v))
    end)

    storage = Repo.get(Storage, mapped_parameters["storage_id"])
    changeset = Image.changeset(%Image{}, mapped_parameters)
    if changeset.valid? do
      resized_images = ResizeImages.call(image_params["data"].path, mapped_parameters["dimensions"], mapped_parameters["name"])
      Enum.each(resized_images, fn (path) -> AzureBlob.put(path, storage, mapped_parameters["container"]) end)

      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Image created successfully.")
      |> redirect(to: image_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Repo.get(Image, id) |> Repo.preload([:storage])
    render(conn, "show.html", image: image)
  end

  def delete(conn, %{"id" => id}) do
    image = Repo.get(Image, id)
    Repo.delete(image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: image_path(conn, :index))
  end

  def transform_parameters(name, value) do
    case {name, value} do
      { "dimensions", dimensions } -> Enum.map(String.split(dimensions, ","), fn(i) -> String.strip(i) end)
      _ -> value
    end
  end

  def available_storages do
    storages = Repo.all(Storage)
    Enum.map(storages, fn (storage) -> { storage.name, storage.id } end)
  end
end
