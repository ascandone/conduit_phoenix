defmodule ConduitWeb.ArticleJSONTest do
  use Conduit.DataCase

  alias Conduit.Accounts.User
  alias Conduit.Blog.Article
  alias ConduitWeb.ArticleJSON

  @example_user %User{
    username: "jake",
    bio: "I work at statefarm",
    image: "https://i.stack.imgur.com/xHWG8.jpg"
  }

  @example_article %Article{
    slug: "how-to-train-your-dragon",
    title: "How to train your dragon",
    description: "Ever wonder how?",
    body: "It takes a Jacobian",
    inserted_at: ~U[2015-01-13T13:00:07.123+00:00],
    updated_at: ~U[2015-01-13T13:00:07.123+00:00],
    author: @example_user
  }

  test "show/1" do
    assert ArticleJSON.show(%{
             article: @example_article,
             favorited?: true,
             favorites_count: 42
           }) == %{
             "article" => %{
               "slug" => @example_article.slug,
               "title" => @example_article.title,
               "description" => @example_article.description,
               "body" => @example_article.body,
               "insertedAt" => @example_article.inserted_at,
               "updatedAt" => @example_article.updated_at,
               "favorited" => true,
               "favoritesCount" => 42,
               "author" => %{
                 "username" => @example_user.username,
                 "bio" => @example_user.bio,
                 "image" => @example_user.image,
                 "following" => false
               }
             }
           }
  end

  test "index/1" do
    article1 = @example_article
    article2 = Map.put(@example_article, "slug", "slug-2")

    assert %{"articles" => [article_json_1, article_json_2]} =
             ArticleJSON.index(%{articles: [article1, article2]})

    assert article_json_1["slug"] == article1.slug
    assert article_json_2["slug"] == article2.slug

    # TODO articles count
  end
end
