defmodule ConduitWeb.Resolvers.Content do
  alias Conduit.{Accounts, Blog}
  alias Conduit.Accounts.User

  def list_articles(parent, _args, _resolution) do
    articles = Blog.list_articles(author: Map.get(parent, :username))
    {:ok, articles}
  end

  def get_article(_parent, %{slug: slug}, _resolution) do
    article = Blog.get_article_by_slug(slug)

    case article do
      nil ->
        {:ok, nil}

      _ ->
        {:ok, article}
    end
  end

  defp profile_to_gql(%User{} = profile) do
    %{
      username: profile.username,
      bio: profile.bio,
      image: profile.image
    }
  end

  def get_profile(_parent, %{username: username}, _resolution) do
    user = Accounts.get_user_by_username(username)

    case user do
      nil -> {:ok, nil}
      _ -> {:ok, user}
    end
  end

  def get_profile(%{author_id: id}, _args, _resolution) do
    user = Accounts.get_user_by_id(id)

    case user do
      nil -> {:ok, nil}
      _ -> {:ok, profile_to_gql(user)}
    end
  end

  def get_current_user(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def get_user_profile(parent, _args, _resolution) do
    {:ok, parent}
  end

  def get_comment_by_id(_parent, %{id: id}, _resolution) do
    comment = Blog.get_comment_by_id(id)
    {:ok, comment}
  end
end
