defmodule ConduitWeb.UserViewTest do
  use Conduit.DataCase

  alias Conduit.Accounts.User
  alias ConduitWeb.UserJson

  @example_user %User{
    email: "example@mail.com",
    username: "uname",
    password: "password",
    hashed_password: "hashed-password"
  }

  @example_token "example_token"

  test "show/1" do
    assert UserJson.show(%{user: @example_user, token: @example_token}) == %{
             user: %{
               email: @example_user.email,
               username: @example_user.username,
               token: @example_token
             }
           }
  end
end
