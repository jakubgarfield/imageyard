defmodule Imageyard.Router do
  use Imageyard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Imageyard do
    pipe_through :browser # Use the default browser stack

    get "/", ImageController, :new

    resources "/storages", StorageController
    resources "/images", ImageController, only: [:index, :new, :create, :show, :delete]
  end

end
