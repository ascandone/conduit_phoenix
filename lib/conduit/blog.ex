defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Conduit.Repo

  alias Conduit.Blog.Article

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Repo.all(Article)
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
