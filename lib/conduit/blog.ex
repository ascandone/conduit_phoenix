defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Conduit.Repo

  alias Conduit.Accounts.User
  alias Conduit.Blog.{Article, Favorite}
  alias Conduit.Profile.Follow

  @doc """
  Returns the list of articles.

  Available options: `:author`

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles(options \\ []) do
    Article
    |> article_option(:author, options[:author])
    |> article_option(:limit, options[:limit] || 100)
    |> article_option(:offset, options[:offset])
    |> Repo.all()
  end

  defp article_option(query, _, nil) do
    query
  end

  defp article_option(query, :author, username) do
    query
    |> join(:left, [a], u in assoc(a, :author))
    |> where([_, u], u.username == ^username)
    |> select([a, u], a)
  end

  defp article_option(query, :limit, n) do
    limit(query, ^n)
  end

  defp article_option(query, :offset, n) do
    offset(query, ^n)
  end

  @doc """
  Gets a single article.

  ## Examples

      iex> get_article_by_slug(123)
      %Article{}

      iex> get_article_by_slug(456)
      nil

  """
  def get_article_by_slug(slug) do
    Repo.one(from a in Article, where: a.slug == ^slug)
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  def article_preload(article_or_articles) do
    article_or_articles
    |> Repo.preload(:author)
    |> Repo.preload(:favorites)
  end

  @doc """
  Updates an article.

  ## Examples

      iex> update_article(%{field: value})
      {:ok, %Article{}}

      iex> update_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  def delete_article(article) do
    Repo.delete(article)
  end

  def feed(%User{} = user) do
    Repo.all(
      from a in Article,
        join: f in Follow,
        on: f.user_id == ^user.id,
        where: a.author_id == f.target_id
    )
  end

  def favorited?(%User{id: user_id}, %Article{id: article_id}) do
    Repo.exists?(from f in Favorite, where: f.user_id == ^user_id and f.article_id == ^article_id)
  end

  def create_favorite(%User{id: user_id}, %Article{id: article_id}) do
    %Favorite{}
    |> Favorite.changeset(%{user_id: user_id, article_id: article_id})
    |> Repo.insert()
  end

  def delete_favorite(%User{id: user_id}, %Article{id: article_id}) do
    Repo.one(from f in Favorite, where: f.user_id == ^user_id and f.article_id == ^article_id)
    |> Repo.delete()
  end

  def count_favorites(%Article{id: article_id}) do
    Repo.one!(from f in Favorite, where: f.article_id == ^article_id, select: count(f))
  end
end
