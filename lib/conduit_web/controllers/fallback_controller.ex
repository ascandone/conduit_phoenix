defmodule ConduitWeb.FallbackController do
  use ConduitWeb, :controller
  alias ConduitWeb.ErrorJSON

  def call(conn, {:error, :wrong_password}) do
    conn
    |> put_status(:forbidden)
    |> json(ErrorJSON.render_credential_errors())
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:forbidden)
    |> json(ErrorJSON.render_credential_errors())
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(ErrorJSON.render_changeset(changeset))
  end
end
