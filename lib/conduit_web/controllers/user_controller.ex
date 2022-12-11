defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller
  alias Conduit.Accounts
  alias ConduitWeb.UserJson

  action_fallback ConduitWeb.FallbackController

  def show(conn, _params) do
    {user, token} = authenticate(conn)
    json(conn, UserJson.show(user, token))
  end

  def update(conn, params) do
    {user, token} = authenticate(conn)
    user_params = params["user"]
    updated_user = Accounts.update_user(user, user_params)
    json(conn, UserJson.show(updated_user, token))
  end

  def create(conn, params) do
    user = params["user"] || %{}

    with {:ok, user} <- Accounts.register_user(user) do
      handle_user(conn, user)
    end
  end

  defp login_params(attrs) do
    types = %{
      email: :string,
      password: :string
    }

    changeset =
      {%{}, types}
      |> Ecto.Changeset.cast(attrs, Map.keys(types))
      |> Ecto.Changeset.validate_required(Map.keys(types))

    if changeset.valid? do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end

  def login(conn, params) do
    user_params = params["user"] || %{}

    with {:ok, %{email: email, password: password}} <- login_params(user_params),
         {:ok, user} <- Accounts.authenticate_user(email, password) do
      handle_user(conn, user)
    end
  end

  defp authenticate(conn) do
    user = Guardian.Plug.current_resource(conn)
    {:ok, token, _} = Conduit.Guardian.encode_and_sign(user)
    {user, token}
  end

  defp handle_user(conn, user) do
    {:ok, token, _claims} = Conduit.Guardian.encode_and_sign(user)
    json(conn, UserJson.show(user, token))
  end
end
