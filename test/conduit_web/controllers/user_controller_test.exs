defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase, async: true
  alias Conduit.AccountsFixtures

  @example_user %{
    username: "Jacob",
    email: "jake@jake.jake",
    password: "jakejake"
  }

  test "register a new user", %{conn: conn} do
    conn = post(conn, ~p"/api/users", user: @example_user)

    assert %{"user" => user} = json_response(conn, 200)
    assert user["email"] == @example_user.email
    assert user["username"] == @example_user.username
    assert user["token"] != nil
  end

  test "login a registered user", %{conn: conn} do
    post(conn, ~p"/api/users", user: @example_user)

    user = %{email: @example_user.email, password: @example_user.password}
    conn = post(conn, ~p"/api/users/login", user: user)

    assert %{"user" => user} = json_response(conn, 200)
    assert user["email"] == @example_user.email
    assert user["username"] == @example_user.username
    assert user["token"] != nil
  end

  test "get current user", %{conn: conn} do
    user_fixture = AccountsFixtures.user_fixture()

    # TODO handle in setup()
    conn = put_auth_header(conn, user_fixture)

    conn = get(conn, ~p"/api/user")

    assert %{"user" => user} = json_response(conn, 200)
    assert user["username"] == user_fixture.username
  end

  defp put_auth_header(%Plug.Conn{} = conn, %Conduit.Accounts.User{} = user) do
    {:ok, token, _claims} = Conduit.Guardian.encode_and_sign(user)
    Plug.Conn.put_req_header(conn, "authorization", "Token " <> token)
  end
end
