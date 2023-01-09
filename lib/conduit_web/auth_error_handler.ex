defmodule ConduitWeb.AuthErrorHandler do
  use ConduitWeb, :controller
  # alias ConduitWeb.ErrorJSON
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> json(%{
      "status" => "error",
      "message" => "missing authorization credentials"
    })
  end
end
