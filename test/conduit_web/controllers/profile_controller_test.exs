defmodule ConduitWeb.ProfileControllerTest do
  use ConduitWeb.ConnCase, async: true

  import Conduit.AccountsFixtures

  test "fetches a profile", %{conn: conn} do
    user = user_fixture()
    conn = get(conn, ~p"/api/profiles/#{user.username}")

    assert %{"profile" => fetched_user} = json_response(conn, 200)
    assert fetched_user["username"] == user.username
  end

  test "handles not found user", %{conn: conn} do
    conn = get(conn, ~p"/api/profiles/user-not-exists")

    # TODO 404 code
    assert %{"profile" => nil} == json_response(conn, 200)
  end
end
