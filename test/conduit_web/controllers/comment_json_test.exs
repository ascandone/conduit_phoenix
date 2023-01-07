defmodule ConduitWeb.CommentJSONTest do
  use Conduit.DataCase

  alias Conduit.Accounts.User
  alias Conduit.Blog.Comment
  alias ConduitWeb.CommentJSON

  @example_user %User{
    email: "example@mail.com",
    username: "uname",
    password: "password",
    hashed_password: "hashed-password",
    bio: "I work at statefarm",
    image: "https://i.stack.imgur.com/xHWG8.jpg"
  }

  @example_comment %Comment{
    id: 42,
    body: "It takes a Jacobian",
    inserted_at: ~U[2016-02-18T03:22:56.637Z],
    updated_at: ~U[2016-02-18T03:22:56.637Z],
    author: @example_user
  }

  test "show/1" do
    assert CommentJSON.show(%{comment: @example_comment}) == %{
             "comment" => %{
               "id" => @example_comment.id,
               "createdAt" => "2016-02-18T03:22:56.637Z",
               "updatedAt" => "2016-02-18T03:22:56.637Z",
               "body" => @example_comment.body,
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
    assert %{
             "comments" => [c1, c2]
           } = CommentJSON.index(%{comments: [@example_comment, @example_comment]})

    assert c1["id"] == @example_comment.id
    assert c2["id"] == @example_comment.id
  end
end
