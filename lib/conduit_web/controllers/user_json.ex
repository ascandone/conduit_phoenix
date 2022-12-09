defmodule ConduitWeb.UserJson do
  defp user(%{user: user, token: token}) do
    %{
      email: user.email,
      username: user.username,
      token: token,
      bio: user.bio,
      image: user.image
    }
  end

  def show(%{user: user, token: token}) do
    %{user: user(%{user: user, token: token})}
  end
end
