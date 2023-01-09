defmodule ConduitWeb.AuthTest do
  use ConduitWeb.ConnCase, async: true

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, ~p"/api/user"),
        put(conn, ~p"/api/user"),
        get(conn, ~p"/api/articles/feed"),
        post(conn, ~p"/api/articles"),
        get(conn, ~p"/api/articles/feed"),
        post(conn, ~p"/api/articles"),
        put(conn, ~p"/api/articles/:slug"),
        delete(conn, ~p"/api/articles/:slug"),
        post(conn, ~p"/api/articles/:slug/favorite"),
        delete(conn, ~p"/api/articles/:slug/favorite"),
        post(conn, ~p"/api/profiles/:username/follow"),
        delete(conn, ~p"/api/profiles/:username/follow"),
        post(conn, ~p"/api/articles/:slug/comments"),
        delete(conn, ~p"/api/articles/:slug/comments/:id")
      ],
      fn conn ->
        assert json_response(conn, 401)
        assert conn.halted
      end
    )
  end
end
