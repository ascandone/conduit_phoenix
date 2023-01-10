defmodule ConduitWeb.Resolvers.Content do
  alias Conduit.Accounts
  alias Conduit.Blog
  alias Conduit.Accounts.User
  alias Blog.Article

  defp article_to_gql(%Article{} = article) do
    %{
      slug: article.slug,
      title: article.title,
      description: article.description,
      created_at: article.inserted_at,
      body: article.body
    }
  end

  def list_articles(_parent, _args, _resolution) do
    articles = Blog.list_articles()
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
end
