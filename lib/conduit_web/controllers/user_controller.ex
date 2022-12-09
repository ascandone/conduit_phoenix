defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller
  alias Conduit.Accounts
  alias ConduitWeb.UserJson

  def show(conn, _params) do
    # TODO extract
    ["Token " <> token] = Plug.Conn.get_req_header(conn, "authorization")

    {:ok, user, _} = Conduit.Guardian.resource_from_token(token)
    json(conn, UserJson.show(%{user: user, token: token}))
  end

  # TODO handle bad path in args
  def create(conn, %{
        "user" => %{
          "username" => username,
          "email" => email,
          "password" => password
        }
      }) do
    # TODO handle bad path in registration
    {:ok, user} =
      Accounts.register_user(%{
        username: username,
        email: email,
        password: password
      })

    {:ok, token, _claims} = Conduit.Guardian.encode_and_sign(user)

    json(conn, UserJson.show(%{user: user, token: token}))
  end

  def login(conn, %{
        "user" => %{
          "email" => email,
          "password" => password
        }
      }) do
    # TODO handle bad path
    {:ok, user} = Accounts.authenticate_user(email, password)

    # TODO handle bad path
    {:ok, token, _claims} = Conduit.Guardian.encode_and_sign(user)

    # TODO token
    json(conn, UserJson.show(%{user: user, token: token}))
  end
end
