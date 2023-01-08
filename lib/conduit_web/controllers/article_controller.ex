defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller
  plug :put_view, json: ConduitWeb.ArticleJSON
  action_fallback ConduitWeb.FallbackController

  alias Conduit.Blog
  alias Conduit.Accounts.User

  def create(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    article_attrs = params["article"] || %{}
    article_attrs = Map.put(article_attrs, "author_id", user.id)

    with {:ok, created_article} <- Blog.create_article(article_attrs) do
      render(conn, :show, article: Blog.article_preload(created_article, user))
    end
  end

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    preloaded_articles =
      Blog.list_articles(
        author: params["author"],
        offset: params["offset"],
        limit: params["limit"] || 20,
        favorited: params["favorited"]
      )
      |> Enum.map(&Blog.article_preload(&1, user))

    articles_count =
      Blog.count_articles(
        author: params["author"],
        favorited: params["favorited"]
      )

    # TODO articles_count
    render(conn, :index, articles: preloaded_articles, articles_count: articles_count)
  end

  def show(conn, %{"slug" => slug}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, article} <- get_article_by_slug(slug) do
      render(conn, :show, article: Blog.article_preload(article, user))
    end
  end

  def update(conn, %{"slug" => slug} = params) do
    %User{id: author_id} = user = Guardian.Plug.current_resource(conn)

    with {:ok, article} <- get_article_by_slug(slug) do
      if article.author_id != author_id do
        {:error, :forbidden}
      else
        article_attrs = params["article"]

        with {:ok, updated_article} <- Blog.update_article(article, article_attrs) do
          render(conn, :show, article: Blog.article_preload(updated_article, user))
        end
      end
    end
  end

  def delete(conn, %{"slug" => slug} = _params) do
    %User{id: author_id} = Guardian.Plug.current_resource(conn)
    {:ok, article} = get_article_by_slug(slug)

    if article.author_id != author_id do
      {:error, :forbidden}
    else
      Blog.delete_article(article)
      conn
    end
  end

  def favorite(conn, %{"slug" => slug}) do
    user = Guardian.Plug.current_resource(conn)
    article = Blog.get_article_by_slug(slug)

    {:ok, _} = Blog.create_favorite(user, article)

    article = Blog.article_preload(article, user)

    render(conn, :show, article: article)
  end

  def unfavorite(conn, %{"slug" => slug}) do
    user = Guardian.Plug.current_resource(conn)
    article = Blog.get_article_by_slug(slug)

    {:ok, _} = Blog.delete_favorite(user, article)

    article = Blog.article_preload(article, user)

    render(conn, :show, article: article)
  end

  def feed(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    articles =
      user
      |> Blog.feed()
      |> Enum.map(&Blog.article_preload(&1, user))

    # TODO articles count
    render(conn, :index, articles: articles, articles_count: 0)
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
