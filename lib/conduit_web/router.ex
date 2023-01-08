defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

    # error_handler: Conduit.AuthErrorHandler
    plug Guardian.Plug.Pipeline,
      module: Conduit.Guardian

    # plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader, scheme: "Token"
  end

  pipeline :check_authenticated do
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :require_authenticated do
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  # Authorized endpoints
  scope "/api", ConduitWeb do
    pipe_through [:api, :require_authenticated]

    get "/user", UserController, :show
    put "/user", UserController, :update
    get "/articles/feed", ArticleController, :feed
    post "/articles", ArticleController, :create
    put "/articles/:slug", ArticleController, :update
    delete "/articles/:slug", ArticleController, :delete
    post "/articles/:slug/favorite", ArticleController, :favorite
    delete "/articles/:slug/favorite", ArticleController, :unfavorite
    post "/profiles/:username/follow", ProfileController, :follow
    delete "/profiles/:username/follow", ProfileController, :unfollow
    post "/articles/:slug/comments", CommentController, :create
  end

  scope "/api", ConduitWeb do
    pipe_through [:api, :check_authenticated]

    post "/users", UserController, :create
    post "/users/login", UserController, :login

    get "/profiles/:username", ProfileController, :show
    get "/articles", ArticleController, :index
    get "/articles/:slug", ArticleController, :show
    get "/articles/:slug/comments", CommentController, :index
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:conduit, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ConduitWeb.Telemetry
    end
  end
end
