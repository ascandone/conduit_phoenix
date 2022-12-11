defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Conduit.Repo

  alias Conduit.Blog.Article

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
    |> article_option(:limit, options[:limit])
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
    Repo.preload(article_or_articles, :author)
  end
end
