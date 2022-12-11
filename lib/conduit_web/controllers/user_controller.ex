defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller
  alias Conduit.Accounts
  alias ConduitWeb.UserJson
  alias ConduitWeb.ErrorJSON

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

  def create(conn, params) do
    user = params["user"] || %{}

    case Accounts.register_user(user) do
      {:ok, user} ->
        {:ok, token, _claims} = Conduit.Guardian.encode_and_sign(user)
        json(conn, UserJson.show(user, token))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> json(ErrorJSON.render_changeset(changeset))
    end
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
end
