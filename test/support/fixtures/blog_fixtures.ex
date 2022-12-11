defmodule Conduit.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Conduit.Blog` context.
  """

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
        title: attrs[:title] || "Some title #{System.unique_integer([:positive])}",
        author_id: user.id
      })
      |> Conduit.Blog.create_article()

    article
  end
end
