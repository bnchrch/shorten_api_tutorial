defmodule ShortenApiWeb.Router do
  use ShortenApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ShortenApiWeb do
    pipe_through :api
    resources "/links", LinkController, except: [:edit]
  end
end
