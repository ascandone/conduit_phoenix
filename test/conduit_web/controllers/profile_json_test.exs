defmodule ConduitWeb.ProfileJsonTest do
  use Conduit.DataCase

  alias ConduitWeb.ProfileJson
  alias Conduit.Accounts.User

  @example_user %User{
    email: "example@mail.com",
    username: "uname",
    password: "password",
    hashed_password: "hashed-password"
  }

  test "show/1" do
    assert ProfileJson.show(%{user: @example_user}) == %{
             profile: %{
               username: @example_user.username
             }
           }
  end
end
