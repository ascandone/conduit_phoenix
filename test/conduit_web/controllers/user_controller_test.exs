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

    test "returns an error when either the username or the email have been taken", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @example_user)
      conn = post(conn, ~p"/api/users", user: Map.put(@example_user, :username, "fresh-uname"))
      assert %{"errors" => %{"email" => [error_message]}} = json_response(conn, 422)
      assert error_message =~ "been taken"
    end
  end

  describe "POST /users/login" do
    test "login a registered user", %{conn: conn} do
      post(conn, ~p"/api/users", user: @example_user)

      user = %{email: @example_user.email, password: @example_user.password}
      conn = post(conn, ~p"/api/users/login", user: user)

      assert %{"user" => user} = json_response(conn, 200)
      assert user["email"] == @example_user.email
      assert user["username"] == @example_user.username
      assert user["token"] != nil
    end

    test "returns errors when required fields are missing", %{conn: conn} do
      conn = post(conn, ~p"/api/users/login")

      assert %{"errors" => %{"email" => [email_error], "password" => [password_error]}} =
               json_response(conn, 422)

      assert email_error =~ "blank"
      assert password_error =~ "blank"
    end

    test "returns error when email does not exist", %{conn: conn} do
      user = %{email: "invalid-email@example.com", password: "password"}
      conn = post(conn, ~p"/api/users/login", user: user)

      assert %{"errors" => %{"email or password" => [err]}} = json_response(conn, 403)
      assert err =~ "invalid"
    end

    test "returns error when password is not right", %{conn: conn} do
      post(conn, ~p"/api/users", user: @example_user)

      user = %{email: @example_user.email, password: "invalid password"}
      conn = post(conn, ~p"/api/users/login", user: user)

      assert %{"errors" => %{"email or password" => [err]}} = json_response(conn, 403)
      assert err =~ "invalid"
    end
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
