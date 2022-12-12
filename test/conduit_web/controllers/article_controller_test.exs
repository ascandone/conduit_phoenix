defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase, async: true

  alias Conduit.Blog
  import Conduit.AccountsFixtures
  import Conduit.BlogFixtures

  describe "GET /articles" do
    test "should list all the articles", %{conn: conn} do
      user1 = user_fixture(%{username: "author-1"})
      user2 = user_fixture(%{username: "author-2"})

      article1 = article_fixture(%{author_id: user1.id}) |> Blog.article_preload()
      article2 = article_fixture(%{author_id: user2.id}) |> Blog.article_preload()

      conn = get(conn, ~p"/api/articles")
      assert %{"articles" => [article_response_1, article_response_2]} = json_response(conn, 200)

      assert article_response_1["slug"] == article1.slug
      assert article_response_2["slug"] == article2.slug
    end

    test "should handle the `author` filter", %{conn: conn} do
      user1 = user_fixture(%{username: "author-1"})
      user2 = user_fixture(%{username: "author-2"})

      article1 = article_fixture(%{author_id: user1.id}) |> Blog.article_preload()
      article_fixture(%{author_id: user2.id}) |> Blog.article_preload()

      conn = get(conn, ~p"/api/articles?author=#{article1.author.username}")
      assert %{"articles" => [article_response_1]} = json_response(conn, 200)

      assert article_response_1["slug"] == article1.slug
    end

    test "should handle the `offset` filter", %{conn: conn} do
      article_fixture()
      article2 = article_fixture()

      conn = get(conn, ~p"/api/articles?offset=1")
      assert %{"articles" => [article_response_1]} = json_response(conn, 200)

      assert article_response_1["slug"] == article2.slug
    end

    test "should handle the `limit` filter", %{conn: conn} do
      article1 = article_fixture()
      article_fixture()

      conn = get(conn, ~p"/api/articles?limit=1")
      assert %{"articles" => [article_response_1]} = json_response(conn, 200)

      assert article_response_1["slug"] == article1.slug
    end
  end

  describe "GET /articles/:slug" do
    test "should fetch an existing article", %{conn: conn} do
      article_fixture(%{title: "Some title"})
      conn = get(conn, ~p"/api/articles/some-title")
      assert %{"article" => %{"slug" => "some-title"}} = json_response(conn, 200)
    end

    test "should return 404 when the article does not exist", %{conn: conn} do
      conn = get(conn, ~p"/api/articles/article-does-not-exist")

      assert %{"errors" => %{"article" => [err]}} = json_response(conn, 404)
      err =~ "not found"
    end

    test "should populate the favorite field", %{conn: conn} do
      %{conn: conn, user: user} = login(%{conn: conn})

      article = article_fixture()

      {:ok, _} = Blog.create_favorite(user, article)

      conn = get(conn, ~p"/api/articles/#{article.slug}")
      assert %{"article" => %{"favorited" => true}} = json_response(conn, 200)
    end
  end

  describe "PUT /articles/:slug" do
    test "should update the given article", %{conn: conn} do
      user = user_fixture()
      conn = login_with(conn, user)

      article_attrs = %{description: "updated description"}

      article = article_fixture(%{author_id: user.id})
      conn = put(conn, ~p"/api/articles/#{article.slug}", article: article_attrs)

      assert %{"article" => %{"description" => response_descr}} = json_response(conn, 200)
      assert response_descr == article_attrs.description
    end

    test "should not allow updating another user's article", %{conn: conn} do
      article = article_fixture()

      user = user_fixture()
      conn = login_with(conn, user)

      article_attrs = %{description: "updated description"}
      conn = put(conn, ~p"/api/articles/#{article.slug}", article: article_attrs)

      assert _ = json_response(conn, 403)
    end
  end

  describe "POST /articles" do
    setup [:login]

    test "should create an article", %{conn: conn} do
      article_args = %{
        title: "How to train your dragon",
        description: "Ever wonder how?",
        body: "You have to believe"
      }

      conn = post(conn, ~p"/api/articles", %{article: article_args})

      assert %{"article" => article} = json_response(conn, 200)

      assert article["slug"] == "how-to-train-your-dragon"
      assert article["title"] == "How to train your dragon"
      assert article["description"] == "Ever wonder how?"
      assert article["body"] == "You have to believe"
    end

    test "should return error when body is missing", %{conn: conn} do
      conn = post(conn, ~p"/api/articles")

      assert %{
               "errors" => %{
                 "title" => [title_err],
                 "description" => [description_err],
                 "body" => [body_err]
               }
             } = json_response(conn, 422)

      assert title_err =~ "blank"
      assert description_err =~ "blank"
      assert body_err =~ "blank"
    end
  end

  describe "DELETE /articles/:slug" do
    test "should delete the article", %{conn: conn} do
      user = user_fixture()
      conn = login_with(conn, user)

      article = article_fixture(%{author_id: user.id})

      delete(conn, ~p"/api/articles/#{article.slug}")

      assert nil == Blog.get_article_by_slug(article.slug)
    end

    test "should not allow deleting another user's article", %{conn: conn} do
      user = user_fixture()
      conn = login_with(conn, user)

      article = article_fixture()

      conn = delete(conn, ~p"/api/articles/#{article.slug}")
      assert _ = response(conn, 403)

      assert Blog.get_article_by_slug(article.slug) != nil
    end
  end
end
