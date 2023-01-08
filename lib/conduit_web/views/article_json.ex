defmodule ConduitWeb.ArticleJSON do
  alias ConduitWeb.ProfileJSON
  alias Conduit.Blog.Article

  defp article(%{article: %Article{} = article}) do
    %{
      "slug" => article.slug,
      "title" => article.title,
      "description" => article.description,
      "body" => article.body,
      "createdAt" => DateTime.to_iso8601(article.inserted_at),
      "updatedAt" => DateTime.to_iso8601(article.updated_at),
      "author" => ProfileJSON.profile(%{profile: article.author}),
      "favorited" => article.favorited,
      "favoritesCount" => article.favorites_count
    }
  end

  def show(%{article: article}) do
    %{
      "article" => article(%{article: article})
    }
  end

  def index(%{articles: articles, articles_count: articles_count}) do
    %{
      # TODO fix `favorites_count`
      "articles" => Enum.map(articles, fn article -> article(%{article: article}) end),
      "articlesCount" => articles_count
    }
  end
end
