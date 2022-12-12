defmodule ConduitWeb.UserJSONTest do
  use Conduit.DataCase

  alias Conduit.Accounts.User
  alias ConduitWeb.UserJSON

  @example_user %User{
    email: "example@mail.com",
    username: "uname",
    password: "password",
    hashed_password: "hashed-password",
    bio: "I work at statefarm",
    image: "https://i.stack.imgur.com/xHWG8.jpg"
  }

  @example_token "example_token"

  test "show/1" do
    assert UserJSON.show(%{user: @example_user, token: @example_token}) == %{
             "user" => %{
               "email" => @example_user.email,
               "username" => @example_user.username,
               "token" => @example_token,
               "bio" => @example_user.bio,
               "image" => @example_user.image
             }
           }
  end
end
