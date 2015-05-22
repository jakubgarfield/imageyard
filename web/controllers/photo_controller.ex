require IEx

defmodule Imageyard.PhotoController do
  use Imageyard.Web, :controller

  alias Imageyard.Photo

  import Mogrify

  plug :scrub_params, "photo" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    photos = Repo.all(Photo) |> Repo.preload([:storage])
    render(conn, "index.html", photos: photos)
  end

  def new(conn, _params) do
    changeset = Photo.changeset(%Photo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"photo" => photo_params}) do
    mapped_parameters = Enum.reduce(photo_params, %{}, fn({k,v}, map) ->
      Map.put(map, k, transform_parameters(k, v))
    end)

    # generate thumbnails
    ensure_output
    input = open(photo_params["data"].path)
    parent = self
    pids = Enum.map(mapped_parameters["dimensions"], fn (dimension) ->
      spawn fn ->
        send(parent, { self(), resize_image(input, dimension, mapped_parameters["name"]) })
      end
    end)

    resized_images = Enum.map(pids, fn (pid) ->
      receive do
        { pid, result } -> result
      end
    end)


    # upload to azure
    storage = Repo.get(Imageyard.Storage, mapped_parameters["storage_id"])
    Enum.each(resized_images, fn (path) ->
      filename = List.last(String.split(path, "/"))
      {:ok, pid} = :erlazure.start(String.to_char_list(storage.name), String.to_char_list(storage.key))
      :erlazure.put_block_blob(pid, String.to_char_list(mapped_parameters["container"]), String.to_char_list(filename), File.read!(path))
    end)


    # save to db
    changeset = Photo.changeset(%Photo{}, mapped_parameters)
    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Photo created successfully.")
      |> redirect(to: photo_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    photo = Repo.get(Photo, id) |> Repo.preload([:storage])
    render(conn, "show.html", photo: photo)
  end

  def delete(conn, %{"id" => id}) do
    photo = Repo.get(Photo, id)
    Repo.delete(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: photo_path(conn, :index))
  end

  def transform_parameters(name, value) do
    case {name, value} do
      { "dimensions", dimensions } -> Enum.map(String.split(dimensions, ","), fn(i) -> String.strip(i) end)
      _ -> value
    end
  end

  def ensure_output(directory \\ "/Users/jakub/projects/elixir/output") do
    File.rm_rf!(directory)
    File.mkdir!(directory)
  end

  def resize_image(input, dimension, filename) do
    output_file = "/Users/jakub/projects/elixir/output/#{filename}-#{dimension}.jpg"
    input |> copy |> resize(dimension) |> save(output_file)
    output_file
  end
end
