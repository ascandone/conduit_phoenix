defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller
  plug :put_view, json: ConduitWeb.ArticleJSON
  action_fallback ConduitWeb.FallbackController

  alias Conduit.Blog
  alias Conduit.Accounts.User

  def create(conn, params) do
    %User{id: id} = Guardian.Plug.current_resource(conn)

    article_attrs = params["article"] || %{}
    article_attrs = Map.put(article_attrs, "author_id", id)

    with {:ok, created_article} <- Blog.create_article(article_attrs) do
      # TODO fix `favorited?`, `favorites_count`
      render(conn, :show,
        article: Blog.article_preload(created_article),
        favorited?: false,
        favorites_count: 0
      )
    end
  end

  def index(conn, params) do
    preloaded_articles =
      Blog.list_articles(
        author: params["author"],
        offset: params["offset"],
        limit: params["limit"]
      )
      |> Blog.article_preload()

    # TODO fix `favorited?`, `favorites_count`
    render(conn, :index, articles: preloaded_articles, favorited?: false, favorites_count: 0)
  end

  def show(conn, %{"slug" => slug}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, article} <- get_article_by_slug(slug) do
      favorited? =
        if user != nil do
          Blog.favorited?(user, article)
        else
          false
        end

      favorites_count = Blog.count_favorites(article)

      render(conn, :show,
        article: Blog.article_preload(article),
        favorited?: favorited?,
        favorites_count: favorites_count
      )
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
          # TODO fix `favorited?`, `favorites_count`
          render(conn, :show,
            article: Blog.article_preload(updated_article),
            favorited?: false,
            favorites_count: 0
          )
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

    article = Blog.article_preload(article)

    # TODO fix `favorited?`, `favorites_count`
    render(conn, :show,
      article: article,
      favorited?: true,
      favorites_count: 1
    )
  end

  def unfavorite(conn, %{"slug" => slug}) do
    user = Guardian.Plug.current_resource(conn)
    article = Blog.get_article_by_slug(slug)

    {:ok, _} = Blog.delete_favorite(user, article)

    article = Blog.article_preload(article)

    # TODO fix `favorited?`, `favorites_count`
    render(conn, :show,
      article: article,
      favorited?: false,
      favorites_count: 0
    )
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
