defmodule ItemsServiceWeb.Router do
  use ItemsServiceWeb, :router

  pipeline :api do
    plug JSONAPI.EnsureSpec
    plug :accepts, ["json"]
  end

  scope "/api", ItemsServiceWeb do
    pipe_through :api
    get "/items", ItemController, :index
    get "/items/*id_or_names_path", ItemController, :get_by_id_or_names_path
  end
end
