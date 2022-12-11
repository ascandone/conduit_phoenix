defmodule Conduit.Profile do
  @moduledoc """
  The Profile context.
  """

  import Ecto.Query, warn: false

  alias Conduit.Repo
  alias Conduit.Accounts.User
  alias Conduit.Profile.Follow

  defp query_follow(%User{id: user_id}, %User{id: target_id}) do
    Repo.one(from f in Follow, where: f.user_id == ^user_id and f.target_id == ^target_id)
  end

  def following?(%User{} = user, %User{} = target) do
    query_follow(user, target) != nil
  end

  def follow(%User{id: user_id}, %User{id: target_id}) do
    %Follow{}
    |> Follow.changeset(%{user_id: user_id, target_id: target_id})
    |> Repo.insert()
  end

  def unfollow(%User{} = user, %User{} = target) do
    follow = query_follow(user, target)

    case follow do
      nil -> nil
      _ -> Repo.delete(follow)
    end
  end
end
