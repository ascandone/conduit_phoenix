defmodule ConduitWeb.ProfileControllerTest do
  use ConduitWeb.ConnCase, async: true

  alias Conduit.Profile
  import Conduit.AccountsFixtures

  describe "GET /profiles/:username" do
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

    test "when logged in, show when profile is followed", %{conn: conn} do
      self = user_fixture()
      target = user_fixture()
      Profile.follow(self, target)

      conn = login_with(conn, self)
      conn = get(conn, ~p"/api/profiles/#{target.username}")

      # TODO 404 code
      assert %{"profile" => %{"following" => true}} = json_response(conn, 200)
    end
  end

  describe "POST /profiles/:username/follow" do
    setup [:login]

    test "should follow an user", %{conn: conn, user: user} do
      target = user_fixture()
      conn = post(conn, ~p"/api/profiles/#{target.username}/follow")
      assert %{"profile" => %{"following" => true}} = json_response(conn, 200)

      assert Profile.following?(user, target) == false
    end
  end
end
