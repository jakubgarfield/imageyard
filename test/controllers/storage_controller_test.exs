defmodule Imageyard.StorageControllerTest do
  use Imageyard.ConnCase

  alias Imageyard.Storage
  @valid_attrs %{key: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, storage_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing storages"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, storage_path(conn, :new)
    assert html_response(conn, 200) =~ "New storage"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, storage_path(conn, :create), storage: @valid_attrs
    assert redirected_to(conn) == storage_path(conn, :index)
    assert Repo.get_by(Storage, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, storage_path(conn, :create), storage: @invalid_attrs
    assert html_response(conn, 200) =~ "New storage"
  end

  test "shows chosen resource", %{conn: conn} do
    storage = Repo.insert %Storage{}
    conn = get conn, storage_path(conn, :show, storage)
    assert html_response(conn, 200) =~ "Show storage"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    storage = Repo.insert %Storage{}
    conn = get conn, storage_path(conn, :edit, storage)
    assert html_response(conn, 200) =~ "Edit storage"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    storage = Repo.insert %Storage{}
    conn = put conn, storage_path(conn, :update, storage), storage: @valid_attrs
    assert redirected_to(conn) == storage_path(conn, :index)
    assert Repo.get_by(Storage, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    storage = Repo.insert %Storage{}
    conn = put conn, storage_path(conn, :update, storage), storage: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit storage"
  end

  test "deletes chosen resource", %{conn: conn} do
    storage = Repo.insert %Storage{}
    conn = delete conn, storage_path(conn, :delete, storage)
    assert redirected_to(conn) == storage_path(conn, :index)
    refute Repo.get(Storage, storage.id)
  end
end
