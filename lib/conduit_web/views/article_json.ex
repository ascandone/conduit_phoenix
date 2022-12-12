defmodule ConduitWeb.ArticleJSON do
  alias ConduitWeb.ProfileJSON
  alias Conduit.Blog.Article

  defp article(%{
         article: %Article{} = article,
         favorited?: favorited?,
         favorites_count: favorites_count
       }) do
    %{
      "slug" => article.slug,
      "title" => article.title,
      "description" => article.description,
      "body" => article.body,
      "insertedAt" => article.inserted_at,
      "updatedAt" => article.updated_at,
      # TODO fix following
      "author" => ProfileJSON.profile(%{profile: article.author, following: false}),
      "favorited" => favorited?,
      "favoritesCount" => favorites_count
    }
  end

  def show(%{
        article: article,
        favorited?: favorited?,
        favorites_count: favorites_count
      }) do
    %{
      "article" =>
        article(%{
          article: article,
          favorited?: favorited?,
          favorites_count: favorites_count
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
          &article(%{
            article: &1,
            favorited?: false,
            favorites_count: 0
          })
        )
    }
  end
end
