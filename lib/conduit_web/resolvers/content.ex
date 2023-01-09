defmodule ConduitWeb.Resolvers.Content do
  alias Conduit.Blog
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
    {:ok, article_to_gql(article)}
  end
end
