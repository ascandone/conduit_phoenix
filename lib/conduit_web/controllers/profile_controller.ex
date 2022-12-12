defmodule ConduitWeb.ProfileController do
  use ConduitWeb, :controller
  plug :put_view, json: ConduitWeb.ProfileJSON

  alias Conduit.Accounts
  alias Conduit.Profile

  def show(conn, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)
    current_user = Guardian.Plug.current_resource(conn)

    following? =
      if current_user != nil do
        Profile.following?(current_user, user)
      else
        false
      end

    render(conn, :show, profile: user, following: following?)
  end

  def follow(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)

    if user == nil do
      {:error, :unauthorized}
    else
      target = Accounts.get_user_by_username(username)
      {:ok, _} = Profile.follow(user, target)
      render(conn, :show, profile: target, following: true)
    end
  end

  def unfollow(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)

    if user == nil do
      {:error, :unauthorized}
    else
      target = Accounts.get_user_by_username(username)
      Profile.unfollow(user, target)
      render(conn, :show, profile: target, following: false)
    end
  end
end
