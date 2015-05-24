defmodule Imageyard.ResizeImages do
  import Mogrify

  def call(path, dimensions, filename) do
    ensure_output
    input = open(path)
    parent = self
    pids = Enum.map(dimensions, fn (dimension) ->
      spawn fn ->
        send(parent, { self(), resize_image(input, dimension, filename) })
      end
    end)

    resized_images = Enum.map(pids, fn (pid) ->
      receive do
        { pid, result } -> result
      end
    end)
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
