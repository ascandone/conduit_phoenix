defmodule ConduitWeb.UserJSON do
  alias Conduit.Accounts.User

  defp user(%User{} = user, token) do
    %{
      "email" => user.email,
      "username" => user.username,
      "token" => token,
      "bio" => user.bio,
      "image" => user.image
    }
  end

  def show(%{user: user, token: token}) do
    %{"user" => user(user, token)}
  end
end
