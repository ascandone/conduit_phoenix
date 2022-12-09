defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog

  describe "articles" do
    alias Conduit.Blog.Article

    import Conduit.BlogFixtures
    import Conduit.AccountsFixtures

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Blog.list_articles() == [article]
    end

    test "get_article_by_slug/1 returns the article with given id" do
      slug = "example-slug"
      article = article_fixture(%{slug: slug})
      assert Blog.get_article_by_slug(slug) == article
    end

    test "create_article/1 with valid data creates a article" do
      user = user_fixture()

      valid_attrs = %{
        body: "some body",
        description: "some description",
        slug: "some slug",
        title: "some title",
        author_id: user.id
      }

      assert {:ok, %Article{} = article} = Blog.create_article(valid_attrs)
      assert article.body == "some body"
      assert article.description == "some description"
      assert article.slug == "some slug"
      assert article.title == "some title"
      assert article.author_id == user.id

      article = Blog.article_preload(article)
      assert article.author.username == user.username
    end
  end
end
