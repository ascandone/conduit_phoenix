defmodule Conduit.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Conduit.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    username = "user#{System.unique_integer([:positive])}"

    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: username,
        email: "#{username}@example.com",
        password: "password"
      })
      |> Conduit.Accounts.register_user()

    user
  end

  def login_with(conn, user) do
    {:ok, token, _claims} = Conduit.Guardian.encode_and_sign(user)
    Plug.Conn.put_req_header(conn, "authorization", "Token " <> token)
  end

  def login(%{conn: conn}) do
    user = user_fixture()
    conn = login_with(conn, user)
    %{conn: conn, user: user}
  end
end
