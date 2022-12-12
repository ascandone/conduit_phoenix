defmodule ConduitWeb.ProfileController do
  use ConduitWeb, :controller
  plug :put_view, json: ConduitWeb.ProfileJSON

  alias Conduit.Accounts

  def show(conn, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)
    render(conn, :show, profile: user)
  end
end
