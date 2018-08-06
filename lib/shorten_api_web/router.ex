defmodule ShortenApiWeb.Router do
  use ShortenApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ShortenApiWeb do
    pipe_through :api
    resources "/links", LinkController, except: [:edit]
  end

  scope "/", ShortenApiWeb do
    get "/:id", LinkController, :get_and_redirect
  end
end
