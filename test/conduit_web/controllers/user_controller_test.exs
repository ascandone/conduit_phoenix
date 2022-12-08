defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase, async: true

  @example_user %{
    username: "Jacob",
    email: "jake@jake.jake",
    password: "jakejake"
  }

  test "POST /api/users", %{conn: conn} do
    conn = post(conn, "/api/users", user: @example_user)

    assert %{"user" => user} = json_response(conn, 200)
    assert user["email"] == @example_user.email
    assert user["username"] == @example_user.username
    assert not Map.has_key?(user, "password")
    assert not Map.has_key?(user, "hashed_password")
    assert user["token"] != nil
  end
end
