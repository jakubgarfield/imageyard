defmodule Imageyard.ResizeImages do
  import Mogrify
  alias Imageyard.Image

  def call(path, dimensions, filename) do
    directory = Path.dirname(path)
    input = open(path)
    parent = self
    pids = Enum.map(dimensions, fn (dimension) ->
      spawn fn ->
        send(parent, { self(), resize_image(input, dimension, filename, directory) })
      end
    end)

    resized_images = Enum.map(pids, fn (pid) ->
      receive do
        { pid, result } -> result
      end
    end)
  end

  def resize_image(input, dimension, filename, directory) do
    output_file = Path.join(directory, Image.full_filename(filename, dimension))
    input |> copy |> resize(dimension) |> save(output_file)
    output_file
  end
end
