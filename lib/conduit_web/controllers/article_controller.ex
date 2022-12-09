defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller
  alias Conduit.Blog

  alias Conduit.Accounts.User
  alias ConduitWeb.ArticleJson

  def create(conn, %{"article" => article_attrs}) do
    %User{id: id} = Guardian.Plug.current_resource(conn)
    article_attrs = Map.put(article_attrs, "author_id", id)

    {:ok, created_article} = Blog.create_article(article_attrs)

    article_json =
      created_article
      |> Blog.article_preload()
      |> ArticleJson.show()

    json(conn, article_json)
  end

  def index(conn, _params) do
    articles_json =
      Blog.list_articles()
      |> Blog.article_preload()
      |> ArticleJson.index()

    json(conn, articles_json)
  end
end
