defmodule Conduit.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Conduit.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    username = "user#{System.unique_integer([:positive])}"

    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: username,
        email: "#{username}@example.com",
        password: "password"
      })
      |> Conduit.Accounts.register_user()

    user
  end
end
