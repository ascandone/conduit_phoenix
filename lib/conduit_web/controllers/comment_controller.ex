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

  def create(conn, %{"slug" => slug} = params) do
    comment_params = params["comment"] || %{}

    article = Blog.get_article_by_slug(slug)
    user = Guardian.Plug.current_resource(conn)

    {:ok, comment} = Blog.create_comment(%{body: comment_params["body"]}, article, user)

    comment = Blog.preload_comment(comment)

    render(conn, :show, comment: comment)
  end

  def delete(conn, %{"slug" => _slug, "id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    comment = Blog.get_comment_by_id(id)

    if user.id == comment.author_id do
      {:ok, _} = Blog.delete_comment(comment)
      conn
    else
      {:error, :unauthorized}
    end
  end
end
