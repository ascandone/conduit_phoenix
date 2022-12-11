defmodule Conduit.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Conduit.Blog` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        description: "some description",
        title: attrs[:title] || "Some title #{System.unique_integer([:positive])}",
        author_id: attrs[:author_id] || Conduit.AccountsFixtures.user_fixture().id
      })
      |> Conduit.Blog.create_article()

    article
  end
end
