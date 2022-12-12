defmodule ConduitWeb.ArticleJSON do
  alias ConduitWeb.ProfileJSON
  alias Conduit.Blog.Article

  defp article(%Article{} = article) do
    %{
      "slug" => article.slug,
      "title" => article.title,
      "description" => article.description,
      "body" => article.body,
      "insertedAt" => article.inserted_at,
      "updatedAt" => article.updated_at,
      # TODO fix following
      "author" => ProfileJSON.profile(%{profile: article.author, following: false})
    }
  end

  def show(%{article: article}) do
    %{"article" => article(article)}
  end

  def index(%{articles: articles}) do
    # TODO articles count
    %{
      "articles" => Enum.map(articles, &article/1)
    }
  end
end
