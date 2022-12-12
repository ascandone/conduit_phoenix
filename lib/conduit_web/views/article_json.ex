defmodule ConduitWeb.ArticleJSON do
  alias ConduitWeb.ProfileJSON
  alias Conduit.Blog.Article

  defp article(%{
         article: %Article{} = article,
         favorited?: favorited?
       }) do
    %{
      "slug" => article.slug,
      "title" => article.title,
      "description" => article.description,
      "body" => article.body,
      "createdAt" => DateTime.to_iso8601(article.inserted_at),
      "updatedAt" => DateTime.to_iso8601(article.updated_at),
      # TODO fix following
      "author" => ProfileJSON.profile(%{profile: article.author, following: false}),
      "favorited" => favorited?,
      "favoritesCount" => Enum.count(article.favorites)
    }
  end

  def show(%{
        article: article,
        favorited?: favorited?
      }) do
    %{
      "article" =>
        article(%{
          article: article,
          favorited?: favorited?
        })
    }
  end

  def index(%{articles: articles}) do
    # TODO articles count
    %{
      # TODO fix `favorited?`, `favorites_count`
      "articles" =>
        Enum.map(
          articles,
          &article(%{article: &1, favorited?: false})
        )
    }
  end
end
