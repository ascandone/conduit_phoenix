defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog.Comment
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

    test "list_articles/1 filters by favorited param" do
      user = user_fixture()

      article1 = article_fixture()
      article_fixture()

      Blog.create_favorite(user, article1)

      assert Blog.list_articles(favorited: user.username) == [article1]
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

    test "feed/1 handles the `limit` option" do
      user = user_fixture()
      u1 = user_fixture()
      Profile.follow(user, u1)

      article_fixture(%{author_id: u1.id})
      article_fixture(%{author_id: u1.id})
      article_fixture(%{author_id: u1.id})

      articles = Blog.feed(user, limit: 2)
      assert Enum.count(articles) == 2
    end

    test "feed/1 handles the `offset` option" do
      user = user_fixture()
      u1 = user_fixture()
      Profile.follow(user, u1)

      article_fixture(%{author_id: u1.id})
      a1 = article_fixture(%{author_id: u1.id})
      a2 = article_fixture(%{author_id: u1.id})

      assert [res_a1, res_a2] = Blog.feed(user, offset: 1)
      assert res_a1.id == a1.id
      assert res_a2.id == a2.id
    end

    test "count_feed_articles/1 return the feed articles count" do
      user = user_fixture()
      u1 = user_fixture()
      Profile.follow(user, u1)

      for _ <- 1..3 do
        article_fixture(%{author_id: u1.id})
      end

      assert Blog.count_feed_articles(user) == 3
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

      article = Blog.article_preload(article, user)
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

    test "create_favorite/2 should return a changeset error when called twice" do
      user = user_fixture()
      article = article_fixture()

      assert {:ok, _} = Blog.create_favorite(user, article)
      assert {:error, _} = Blog.create_favorite(user, article)
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

    test "an user should be able to create comments" do
      comment_text = "hello world!"

      article = article_fixture()
      comment_author = user_fixture()

      assert {:ok, %Comment{} = comment} =
               Blog.create_comment(%{body: comment_text}, article, comment_author)

      assert comment.body == comment_text

      fetched_comment = Blog.get_comment_by_id(comment.id)

      assert comment == fetched_comment
    end

    test "Blog.get_comment_by_id/1 should return nil when no comment is found" do
      assert Blog.get_comment_by_id(42) == nil
    end

    test "Blog.get_article_comments/1 should return created articles" do
      article = article_fixture()
      {:ok, comment1} = Blog.create_comment(%{body: "comment-1"}, article, user_fixture())
      {:ok, comment2} = Blog.create_comment(%{body: "comment-2"}, article, user_fixture())

      assert [comment1, comment2] == Blog.get_article_comments(article)
    end

    test "Blog.preload_comment/1 should preload author data" do
      article = article_fixture()

      author = user_fixture()
      {:ok, %Comment{id: id}} = Blog.create_comment(%{body: "comment-1"}, article, author)

      comment = Blog.get_comment_by_id(id) |> Blog.preload_comment()

      assert comment.author.username == author.username
    end

    test "Blog.delete_comment/1 should delete an existing comment" do
      {:ok, comment} =
        Blog.create_comment(%{body: "comment-1"}, article_fixture(), user_fixture())

      assert {:ok, old_comment} = Blog.delete_comment(comment)

      assert comment.id == old_comment.id
      assert Blog.get_comment_by_id(comment.id) == nil
    end
  end
end
