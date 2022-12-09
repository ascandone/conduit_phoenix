defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller
  alias Conduit.Accounts
  alias ConduitWeb.UserJson

  defp authenticate(conn) do
    user = Guardian.Plug.current_resource(conn)
    {:ok, token, _} = Conduit.Guardian.encode_and_sign(user)
    {user, token}
  end

  def show(conn, _params) do
    {user, token} = authenticate(conn)
    json(conn, UserJson.show(user, token))
  end

  def update(conn, %{"user" => params}) do
    {user, token} = authenticate(conn)

    updated_user = Accounts.update_user(user, params)
    json(conn, UserJson.show(updated_user, token))
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

    json(conn, UserJson.show(user, token))
  end

  def create(conn, params) do
    user = params["user"] || %{}

    errors = required_fields_validation(user, ["username", "email", "password"])
    conn |> put_status(422) |> json(%{"errors" => errors})
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
    json(conn, UserJson.show(user, token))
  end

  defp required_fields_validation(attrs, required_fields) do
    for field <- required_fields,
        !Map.has_key?(attrs, field) do
      {field, ["can't be blank"]}
    end
    |> Enum.into(%{})
  end
end
