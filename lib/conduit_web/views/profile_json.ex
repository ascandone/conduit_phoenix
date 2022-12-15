defmodule ConduitWeb.ProfileJSON do
  alias Conduit.Accounts.User

  def show(%{profile: nil}) do
    %{"profile" => nil}
  end

  def show(%{profile: %User{} = user}) do
    %{"profile" => profile(%{profile: user})}
  end

  def profile(%{profile: %User{} = user}) do
    %{
      "username" => user.username,
      "bio" => user.bio,
      "image" => user.image,
      "following" => user.following
    }
  end
end
