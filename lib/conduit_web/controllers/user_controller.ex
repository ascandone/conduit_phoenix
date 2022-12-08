defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller
  alias Conduit.Accounts
  alias ConduitWeb.UserJson

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
end
