defmodule ConduitWeb.CommentController do
  use ConduitWeb, :controller
  plug :put_view, json: ConduitWeb.CommentJSON
  action_fallback ConduitWeb.FallbackController

  alias Conduit.Blog

  def index(conn, %{"slug" => slug}) do
    article = Blog.get_article_by_slug(slug)
    comments = Blog.get_article_comments(article) |> Enum.map(&Blog.preload_comment/1)
    render(conn, :index, comments: comments)
  end
end
