defmodule ConduitWeb.ProfileJSON do
  alias Conduit.Accounts.User

  def show(%{profile: nil}) do
    %{"profile" => nil}
  end

  def show(%{profile: %User{} = user, following: following}) do
    %{"profile" => profile(%{profile: user, following: following})}
  end

  def profile(%{profile: %User{} = user, following: following}) do
    %{
      "username" => user.username,
      "bio" => user.bio,
      "image" => user.image,
      "following" => following
    }
  end
end
