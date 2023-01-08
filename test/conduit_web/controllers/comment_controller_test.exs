defmodule ConduitWeb.CommentControllerTest do
  use ConduitWeb.ConnCase, async: true

  alias Conduit.Blog
  import Conduit.AccountsFixtures
  import Conduit.BlogFixtures

  describe "GET /articles/:slug/comments" do
    test "should list all the comments of an article", %{conn: conn} do
      article = article_fixture()
      user = user_fixture()

      {:ok, comment_1} = Blog.create_comment(%{body: "comment 1"}, article, user)
      {:ok, comment_2} = Blog.create_comment(%{body: "comment 2"}, article, user)

      conn = get(conn, ~p"/api/articles/#{article.slug}/comments")
      assert %{"comments" => [comment_response_1, comment_response_2]} = json_response(conn, 200)

      assert comment_response_1["body"] == comment_1.body
      assert comment_response_2["body"] == comment_2.body
    end
  end

  describe "POST /articles/:slug/comments" do
    setup [:login]

    test "should add a comment to an article", %{conn: conn} do
      article = article_fixture()
      example_body = "example body"

      conn =
        post(conn, ~p"/api/articles/#{article.slug}/comments", comment: %{body: example_body})

      assert %{"comment" => comment} = json_response(conn, 200)

      assert comment["body"] == example_body
      assert comment["author"] != nil
    end
  end

  describe "DELETE /articles/:slug/comments/:id" do
    test "should add a comment to an article", %{conn: conn} do
      author = user_fixture()
      conn = login_with(conn, author)

      article = article_fixture()

      {:ok, comment} = Blog.create_comment(%{body: "example body"}, article, author)

      _conn = delete(conn, ~p"/api/articles/#{article.slug}/comments/#{comment.id}")

      assert Blog.get_comment_by_id(comment.id) == nil
    end
  end
end
