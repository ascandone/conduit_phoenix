defmodule ConduitWeb.ProfileController do
  use ConduitWeb, :controller

  alias Conduit.Accounts
  alias ConduitWeb.ProfileJson

  def show(conn, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)
    json(conn, ProfileJson.show(%{user: user}))
  end
end
