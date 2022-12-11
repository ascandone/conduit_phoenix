defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog

  describe "articles" do
    alias Conduit.Blog.Article

    import Conduit.BlogFixtures
    import Conduit.AccountsFixtures

    test "list_articles/1 returns all articles" do
      article = article_fixture()
      assert Blog.list_articles() == [article]
    end

    test "list_articles/1 filters by author" do
      user1 = user_fixture()
      user2 = user_fixture()

      article1 = article_fixture(%{author_id: user1.id})
      _article2 = article_fixture(%{author_id: user2.id})

      assert Blog.list_articles(author: user1.username) == [article1]
    end

    test "get_article_by_slug/1 returns the article with given id" do
      article = article_fixture(%{title: "example title"})
      assert Blog.get_article_by_slug("example-title") == article
    end

    test "create_article/1 with valid data creates a article" do
      user = user_fixture()

      valid_attrs = %{
        body: "some body",
        description: "some description",
        title: "some title",
        author_id: user.id
      }

      assert {:ok, %Article{} = article} = Blog.create_article(valid_attrs)
      assert article.body == "some body"
      assert article.description == "some description"
      assert article.title == "some title"
      assert article.slug == "some-title"
      assert article.author_id == user.id

      article = Blog.article_preload(article)
      assert article.author.username == user.username
    end
  end
end
