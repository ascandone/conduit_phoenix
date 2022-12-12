defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Profile
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

    test "list_articles/1 handles `limit` option" do
      a1 = article_fixture()
      a2 = article_fixture()
      article_fixture()

      assert Blog.list_articles(limit: 2) == [a1, a2]
    end

    test "list_articles/1 handles `offset` option" do
      article_fixture()
      article_fixture()
      a3 = article_fixture()

      assert Blog.list_articles(offset: 2) == [a3]
    end

    test "list_articles/1 handles `limit` and `offset` option" do
      article_fixture()
      a2 = article_fixture()
      article_fixture()

      assert Blog.list_articles(limit: 1, offset: 1) == [a2]
    end

    test "feed/1 should only return article whose the user is following" do
      user = user_fixture()
      u1 = user_fixture()

      Profile.follow(user, u1)
      a1 = article_fixture(%{author_id: u1.id})

      article_fixture()

      assert [article] = Blog.feed(user)

      assert article.author_id == u1.id
      assert article.id == a1.id
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

    test "create_article/1 handles invalid data" do
      user = user_fixture()

      invalid_attrs = %{
        title: "",
        body: "some body",
        description: "some description",
        author_id: user.id
      }

      assert {:error, %Ecto.Changeset{}} = Blog.create_article(invalid_attrs)
    end

    test "update_article/2 updates the article with valid data" do
      article = article_fixture()

      updated_description = "updated description"

      assert {:ok, %{description: ^updated_description}} =
               Blog.update_article(article, %{description: updated_description})
    end

    test "update_article/2 updates the slug when title is changed" do
      article = article_fixture()

      updated_title = "updated title"

      assert {:ok, %{title: ^updated_title, slug: "updated-title"}} =
               Blog.update_article(article, %{title: updated_title})
    end

    test "update_article/2 does not allow changing slug directly" do
      article = article_fixture()

      assert {:ok, updated_article} = Blog.update_article(article, %{slug: "updated-slug"})

      assert updated_article.slug == article.slug
    end

    test "update_article/2 handles invalid data" do
      article = article_fixture()

      assert {:error, %Ecto.Changeset{}} = Blog.update_article(article, %{title: ""})
    end

    test "favorited?/2 returns false initially" do
      user = user_fixture()
      article = article_fixture()

      assert Blog.favorited?(user, article) == false
    end

    test "create_favorite/2 should make a user favorite an article" do
      user = user_fixture()
      article = article_fixture()

      assert {:ok, _} = Blog.create_favorite(user, article)
      assert Blog.favorited?(user, article)
    end

    test "delete_favorite/2 should remove a favorite" do
      user = user_fixture()
      article = article_fixture()
      {:ok, _} = Blog.create_favorite(user, article)

      {:ok, _} = Blog.delete_favorite(user, article)
      assert Blog.favorited?(user, article) == false
    end

    test "count_favorites/1 should count the favorites number" do
      article = article_fixture()

      assert Blog.count_favorites(article) == 0

      {:ok, _} = Blog.create_favorite(user_fixture(), article)
      {:ok, _} = Blog.create_favorite(user_fixture(), article)

      assert Blog.count_favorites(article) == 2
    end
  end
end
