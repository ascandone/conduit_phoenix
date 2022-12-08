defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase, async: true

  @example_user %{
    username: "Jacob",
    email: "jake@jake.jake",
    password: "jakejake"
  }

  test "register a new user", %{conn: conn} do
    conn = post(conn, "/api/users", user: @example_user)

    assert %{"user" => user} = json_response(conn, 200)
    assert user["email"] == @example_user.email
    assert user["username"] == @example_user.username
    assert not Map.has_key?(user, "password")
    assert not Map.has_key?(user, "hashed_password")
    assert user["token"] != nil
  end

  test "login a registered user", %{conn: conn} do
    post(conn, "/api/users", user: @example_user)

    user = %{email: @example_user.email, password: @example_user.password}
    conn = post(conn, "/api/users/login", user: user)

    assert %{"user" => user} = json_response(conn, 200)
    assert user["email"] == @example_user.email
    assert user["username"] == @example_user.username
    assert not Map.has_key?(user, "password")
    assert not Map.has_key?(user, "hashed_password")
    assert user["token"] != nil
  end
end
