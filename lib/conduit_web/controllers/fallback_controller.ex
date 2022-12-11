defmodule ConduitWeb.FallbackController do
  use ConduitWeb, :controller
  alias ConduitWeb.ErrorJSON

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(ErrorJSON.render_changeset(changeset))
  end
end
