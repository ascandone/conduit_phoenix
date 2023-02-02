defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Conduit.Repo

  alias Conduit.Accounts.User
  alias Conduit.Blog.{Article, Favorite}
  alias Conduit.Profile.Follow
  alias Conduit.Blog.Comment

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
    |> article_option(:favorited, options[:favorited])
    |> article_option(:limit, options[:limit] || 100)
    |> article_option(:offset, options[:offset])
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def count_articles(options) do
    Article
    |> article_option(:author, options[:author])
    |> article_option(:favorited, options[:favorited])
    |> Repo.aggregate(:count)
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

  defp article_option(query, :favorited, username) do
    query
    |> join(:left, [a], f in assoc(a, :favorites))
    |> join(:left, [a, f], u in assoc(f, :user))
    |> where([a, f, u], u.username == ^username)
    |> select([a, f, u], a)
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
    Repo.one(from(a in Article, where: a.slug == ^slug))
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  def article_preload_following_author(%Article{} = article, user) do
    %{article | author: Conduit.Accounts.user_preload(article.author, user)}
  end

  def article_preload_favorited(%Article{} = article, nil) do
    %{article | favorited: false}
  end

  def article_preload_favorited(%Article{} = article, %User{} = user) do
    %{article | favorited: favorited?(user, article)}
  end

  def article_preload_favorite_count(%Article{} = article) do
    %{article | favorites_count: count_favorites(article)}
  end

  def article_preload(%Article{} = article, user) do
    article
    |> Repo.preload(:author)
    |> article_preload_favorite_count()
    |> article_preload_favorited(user)
    |> article_preload_following_author(user)
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

  defp feed_query(%User{id: user_id}) do
    from(a in Article,
      join: f in Follow,
      where: f.user_id == ^user_id and f.target_id == a.author_id,
      order_by: [desc: a.inserted_at]
    )
  end

  def feed(%User{} = user, options \\ []) do
    feed_query(user)
    |> article_option(:limit, options[:limit] || 100)
    |> article_option(:offset, options[:offset])
    |> Repo.all()
  end

  def count_feed_articles(user) do
    feed_query(user)
    |> Repo.aggregate(:count)
  end

  def favorited?(%User{id: user_id}, %Article{id: article_id}) do
    Repo.exists?(
      from(f in Favorite, where: f.user_id == ^user_id and f.article_id == ^article_id)
    )
  end

  def create_favorite(%User{id: user_id}, %Article{id: article_id}) do
    %Favorite{}
    |> Favorite.changeset(%{user_id: user_id, article_id: article_id})
    |> Repo.insert()
  end

  def delete_favorite(%User{id: user_id}, %Article{id: article_id}) do
    Repo.one(from(f in Favorite, where: f.user_id == ^user_id and f.article_id == ^article_id))
    |> Repo.delete()
  end

  def count_favorites(%Article{id: article_id}) do
    Repo.one!(from(f in Favorite, where: f.article_id == ^article_id, select: count(f)))
  end

  def create_comment(%{body: body}, %Article{id: article_id}, %User{id: user_id}) do
    %Comment{}
    |> Comment.changeset(%{
      body: body,
      article_id: article_id,
      author_id: user_id
    })
    |> Repo.insert()
  end

  def get_comment_by_id(id) do
    Repo.get(Comment, id)
  end

  def get_article_comments(%Article{id: article_id}) do
    Repo.all(
      from(c in Comment,
        where: c.article_id == ^article_id
      )
    )
  end

  def preload_comment(%Comment{} = comment) do
    Repo.preload(comment, :author)
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end
end
