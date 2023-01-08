defmodule ConduitWeb.ArticleJSONTest do
  use Conduit.DataCase

  alias Conduit.Accounts.User
  alias Conduit.Blog.{Article, Favorite}
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
    inserted_at: ~U[2016-02-18T03:22:56.637Z],
    updated_at: ~U[2016-02-18T03:48:35.824Z],
    author: @example_user,
    favorites: [%Favorite{}],
    favorited: true,
    favorites_count: 1
  }

  test "show/1" do
    assert ArticleJSON.show(%{article: @example_article}) == %{
             "article" => %{
               "slug" => @example_article.slug,
               "title" => @example_article.title,
               "description" => @example_article.description,
               "body" => @example_article.body,
               "createdAt" => "2016-02-18T03:22:56.637Z",
               "updatedAt" => "2016-02-18T03:48:35.824Z",
               "favorited" => true,
               "favoritesCount" => 1,
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

    assert %{"articles" => [article_json_1, article_json_2], "articlesCount" => 2} =
             ArticleJSON.index(%{articles: [article1, article2], articles_count: 2})

    assert article_json_1["slug"] == article1.slug
    assert article_json_2["slug"] == article2.slug

    # TODO articles count
  end
end
