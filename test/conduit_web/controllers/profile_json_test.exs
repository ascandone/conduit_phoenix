defmodule ConduitWeb.ProfileJSONTest do
  use Conduit.DataCase

  alias ConduitWeb.ProfileJSON
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
    assert ProfileJSON.show(%{profile: @example_user, following: true}) == %{
             "profile" => %{
               "username" => @example_user.username,
               "bio" => @example_user.bio,
               "image" => @example_user.image,
               "following" => true
             }
           }
  end
end
