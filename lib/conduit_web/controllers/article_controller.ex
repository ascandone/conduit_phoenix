defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller
  action_fallback ConduitWeb.FallbackController

  alias Conduit.Blog
  alias Conduit.Accounts.User
  alias ConduitWeb.ArticleJson

  def create(conn, params) do
    %User{id: id} = Guardian.Plug.current_resource(conn)

    article_attrs = params["article"] || %{}
    article_attrs = Map.put(article_attrs, "author_id", id)

    with {:ok, created_article} <- Blog.create_article(article_attrs) do
      article_json =
        created_article
        |> Blog.article_preload()
        |> ArticleJson.show()

      json(conn, article_json)
    end
  end

  def index(conn, params) do
    articles_json =
      Blog.list_articles(
        author: params["author"],
        offset: params["offset"],
        limit: params["limit"]
      )
      |> Blog.article_preload()
      |> ArticleJson.index()

    json(conn, articles_json)
  end

  def show(conn, %{"slug" => slug}) do
    with {:ok, article} <- get_article_by_slug(slug) do
      preloaded_article = article |> Blog.article_preload() |> ArticleJson.show()
      json(conn, preloaded_article)
    end
  end

  def update(conn, %{"slug" => slug} = params) do
    %User{id: author_id} = Guardian.Plug.current_resource(conn)

    with {:ok, article} <- get_article_by_slug(slug) do
      if article.author_id != author_id do
        {:error, :forbidden}
      else
        article_attrs = params["article"]

        with {:ok, updated_article} <- Blog.update_article(article, article_attrs) do
          article_json =
            updated_article
            |> Blog.article_preload()
            |> ArticleJson.show()

          json(conn, article_json)
        end
      end
    end
  end

  defp get_article_by_slug(slug) do
    case Blog.get_article_by_slug(slug) do
      nil ->
        {:error, :not_found, "article"}

      article ->
        {:ok, article}
    end
  end
end
