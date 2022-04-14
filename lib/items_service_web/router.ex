defmodule ItemsServiceWeb.Router do
  use ItemsServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ItemsServiceWeb do
    pipe_through :api
  end
end
