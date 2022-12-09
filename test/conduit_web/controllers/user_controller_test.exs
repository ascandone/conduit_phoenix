defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase, async: true
  import Conduit.AccountsFixtures

  @example_user %{
    username: "Jacob",
    email: "jake@jake.jake",
    password: "jakejake"
  }

  describe "POST /users" do
    test "registers a new user", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @example_user)

      assert %{"user" => user} = json_response(conn, 200)
      assert user["email"] == @example_user.email
      assert user["username"] == @example_user.username
      assert user["token"] != nil
    end

    test "returns error with empty body", %{conn: conn} do
      conn = post(conn, ~p"/api/users")

      assert %{"errors" => %{"email" => _, "password" => _, "username" => _}} =
               json_response(conn, 422)
    end
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

  describe "authorized endpoints" do
    setup [:login]

    test "get current user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/user")

      assert %{"user" => response_user} = json_response(conn, 200)
      assert response_user["username"] == user.username
    end

    test "update user", %{conn: conn} do
      user = %{username: "edited-username"}
      conn = put(conn, ~p"/api/user", %{user: user})

      assert %{"user" => response_user} = json_response(conn, 200)
      assert response_user["username"] == user.username
    end
  end
end
