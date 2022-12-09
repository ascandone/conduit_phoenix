defmodule ConduitWeb.ProfileJsonTest do
  use Conduit.DataCase

  alias ConduitWeb.ProfileJson
  alias Conduit.Accounts.User

  @example_user %User{
    email: "example@mail.com",
    username: "uname",
    password: "password",
    hashed_password: "hashed-password",
    bio: "I work at statefarm",
    image: "https://i.stack.imgur.com/xHWG8.jpg"
  }

  test "show/1" do
    assert ProfileJson.show(@example_user) == %{
             "profile" => %{
               "username" => @example_user.username,
               "bio" => @example_user.bio,
               "image" => @example_user.image
             }
           }
  end
end
