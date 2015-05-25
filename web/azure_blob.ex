defmodule Imageyard.AzureBlob do
  def put(path, storage, container) do
    filename = List.last(String.split(path, "/"))
    {:ok, pid} = :erlazure.start(String.to_char_list(storage.name), String.to_char_list(storage.key))
    :erlazure.put_block_blob(pid, String.to_char_list(container), String.to_char_list(filename), File.read!(path))
  end
end
