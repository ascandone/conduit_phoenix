defmodule Conduit.Blog.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :body, :string
    field :description, :string
    field :slug, :string
    field :title, :string

    belongs_to :author, Conduit.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :body, :author_id])
    |> validate_required([:title, :description, :body, :author_id])
    |> put_slug()
    |> cast_assoc(:author)
    |> unique_constraint(:slug)
  end

  defp put_slug(%Ecto.Changeset{} = changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{title: title}} ->
        put_change(changeset, :slug, title_to_slug(title))

      _ ->
        changeset
    end
  end

  def title_to_slug(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
