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
      Blog.list_articles(author: params["author"])
      |> Blog.article_preload()
      |> ArticleJson.index()

    json(conn, articles_json)
  end

  def show(conn, params) do
    case Blog.get_article_by_slug(params["slug"]) do
      nil ->
        {:error, :not_found, "article"}

      article ->
        preloaded_article = article |> Blog.article_preload() |> ArticleJson.show()
        json(conn, preloaded_article)
    end
  end
end
