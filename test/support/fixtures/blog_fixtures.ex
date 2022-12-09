defmodule Conduit.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Conduit.Blog` context.
  """

  @doc """
  Generate a unique article slug.
  """
  def unique_article_slug, do: "some-slug-#{System.unique_integer([:positive])}"

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    user = Conduit.AccountsFixtures.user_fixture()

    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        description: "some description",
        slug: attrs[:slug] || unique_article_slug(),
        title: "some title",
        author_id: user.id
      })
      |> Conduit.Blog.create_article()

    article
  end
end
