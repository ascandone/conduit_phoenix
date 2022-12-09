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

  defp login(%{conn: conn}) do
    user = AccountsFixtures.user_fixture()
    {:ok, token, _claims} = Conduit.Guardian.encode_and_sign(user)
    conn = Plug.Conn.put_req_header(conn, "authorization", "Token " <> token)
    %{conn: conn, user: user}
  end
end
