defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller
  alias Conduit.Blog
  alias ConduitWeb.ArticleJson

  def create(conn, %{"article" => article_attrs}) do
    user = Guardian.Plug.current_resource(conn)

    article_attrs = Map.put(article_attrs, "author_id", user.id)

    {:ok, created_article} = Blog.create_article(article_attrs)
    preloaded_article = Blog.article_preload(created_article)
    json(conn, ArticleJson.show(preloaded_article))
  end
end
