defmodule ConduitWeb.Resolvers.Content do
  alias Conduit.{Accounts, Blog}
  alias Conduit.Accounts.User
  alias Conduit.Blog.{Article, Comment}

  defp article_to_gql(%Article{} = article) do
    %{
      slug: article.slug,
      title: article.title,
      description: article.description,
      created_at: article.inserted_at,
      body: article.body,
      author_id: article.author_id
    }
  end

  def list_articles(parent, _args, _resolution) do
    articles = Blog.list_articles(author: Map.get(parent, :username))
    {:ok, Enum.map(articles, &article_to_gql/1)}
  end

  def get_article(_parent, %{slug: slug}, _resolution) do
    article = Blog.get_article_by_slug(slug)

    case article do
      nil ->
        {:ok, nil}

      _ ->
        {:ok, article_to_gql(article)}
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
      _ -> {:ok, profile_to_gql(user)}
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

  defp comment_to_gql(%Comment{} = comment) do
    %{
      id: comment.id,
      body: comment.body,
      created_at: comment.inserted_at,
      updated_at: comment.updated_at
    }
  end

  def get_comment_by_id(_parent, %{id: id}, _resolution) do
    comment = Blog.get_comment_by_id(id)
    {:ok, comment_to_gql(comment)}
  end
end
