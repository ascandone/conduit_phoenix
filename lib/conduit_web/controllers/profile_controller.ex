defmodule ConduitWeb.ProfileController do
  use ConduitWeb, :controller
  plug :put_view, json: ConduitWeb.ProfileJSON

  alias Conduit.Accounts
  alias Conduit.Profile

  def show(conn, %{"username" => username}) do
    current_user = Guardian.Plug.current_resource(conn)

    user =
      username
      |> Accounts.get_user_by_username()
      |> Accounts.user_preload(current_user)

    render(conn, :show, profile: user)
  end

  def follow(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)

    if user == nil do
      {:error, :unauthorized}
    else
      target = Accounts.get_user_by_username(username)
      {:ok, _} = Profile.follow(user, target)
      render(conn, :show, profile: %{target | following: true})
    end
  end

  def unfollow(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)
    target = Accounts.get_user_by_username(username)
    Profile.unfollow(user, target)
    render(conn, :show, profile: %{target | following: false})
  end
end
