defmodule Imageyard.AzureRepository do
  def create_blob(path, storage, container) do
    filename = List.last(String.split(path, "/"))
    {:ok, pid} = :erlazure.start(to_char_list(storage.name), to_char_list(storage.key))
    :erlazure.put_block_blob(pid, to_char_list(container), to_char_list(filename), File.read!(path))
  end

  def delete_blob(filename, storage, container) do
    {:ok, pid} = :erlazure.start(to_char_list(storage.name), to_char_list(storage.key))
    :erlazure.delete_blob(pid, to_char_list(container), to_char_list(filename))
  end

  def list_containers(storage) do
    {:ok, pid} = :erlazure.start(to_char_list(storage.name), to_char_list(storage.key))
    {containers, _} = :erlazure.list_containers(pid)
    Enum.map(containers, fn(container) ->
      {type, name, _, attributes, _} = container
      %{name: name, type: type, blobs: list_blobs(storage, to_string(name))}
    end)
  end

  def list_blobs(storage, container) do
    {:ok, pid} = :erlazure.start(to_char_list(storage.name), to_char_list(storage.key))
    {blobs, _} = :erlazure.list_blobs(pid, to_char_list(container))
    Enum.map(blobs, fn(blob) ->
      {type, name, _, _, attributes, _} = blob
      %{name: name, type: type}
    end)
  end

  def delete_container(storage, name) do
    {:ok, pid} = :erlazure.start(to_char_list(storage.name), to_char_list(storage.key))
    :erlazure.delete_container(pid, to_char_list(name))
  end

  def path(storage, container, filename) do
    "https://#{storage.name}.blob.core.windows.net/#{container}/#{filename}"
  end
end
