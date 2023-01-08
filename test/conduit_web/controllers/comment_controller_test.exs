defmodule ConduitWeb.CommentControllerTest do
  use ConduitWeb.ConnCase, async: true

  alias Conduit.Blog
  import Conduit.AccountsFixtures
  import Conduit.BlogFixtures

  describe "GET /articles/:slug/comments" do
    test "should list all the comments of an article", %{conn: conn} do
      article = article_fixture() |> Blog.article_preload(nil)
      user = user_fixture()

      {:ok, comment_1} = Blog.create_comment(%{body: "comment 1"}, article, user)
      {:ok, comment_2} = Blog.create_comment(%{body: "comment 2"}, article, user)

      conn = get(conn, ~p"/api/articles/#{article.slug}/comments")
      assert %{"comments" => [comment_response_1, comment_response_2]} = json_response(conn, 200)

      assert comment_response_1["body"] == comment_1.body
      assert comment_response_2["body"] == comment_2.body
    end
  end
end
