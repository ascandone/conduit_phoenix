defmodule ConduitWeb.ProfileJson do
  alias Conduit.Accounts.User

  def show(%{user: nil}) do
    %{profile: nil}
  end

  def show(%{user: %User{} = user}) do
    %{profile: profile(%{user: user})}
  end

  defp profile(%{user: %User{} = user}) do
    %{
      username: user.username
    }
  end
end
