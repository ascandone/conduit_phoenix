defmodule ConduitWeb.ArticleJson do
  alias ConduitWeb.ProfileJson
  alias Conduit.Blog.Article

  defp article(%Article{} = article) do
    %{
      "slug" => article.slug,
      "title" => article.title,
      "description" => article.description,
      "body" => article.body,
      "insertedAt" => article.inserted_at,
      "updatedAt" => article.updated_at,
      "author" => ProfileJson.profile(article.author)
    }
  end

  def show(article) do
    %{"article" => article(article)}
  end
end
