defmodule ConduitWeb.ArticleJsonTest do
  use Conduit.DataCase

  alias Conduit.Accounts.User
  alias Conduit.Blog.Article
  alias ConduitWeb.ArticleJson

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
    inserted_at: ~N[2018-11-15 10:00:00],
    updated_at: ~N[2019-11-15 10:00:00],
    author: @example_user
  }

  test "show/1" do
    assert ArticleJson.show(@example_article) == %{
             "article" => %{
               "slug" => @example_article.slug,
               "title" => @example_article.title,
               "description" => @example_article.description,
               "body" => @example_article.body,
               "insertedAt" => @example_article.inserted_at,
               "updatedAt" => @example_article.updated_at,
               "author" => %{
                 "username" => @example_user.username,
                 "bio" => @example_user.bio,
                 "image" => @example_user.image
               }
             }
           }
  end
end
