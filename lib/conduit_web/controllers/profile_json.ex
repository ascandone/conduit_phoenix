defmodule ConduitWeb.ProfileJson do
  alias Conduit.Accounts.User

  def show(nil) do
    %{"profile" => nil}
  end

  def show(%User{} = user) do
    %{"profile" => profile(user)}
  end

  def profile(%User{} = user) do
    %{
      "username" => user.username,
      "bio" => user.bio,
      "image" => user.image,
      "following" => user.following
    }
  end
end
