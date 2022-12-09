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
    |> cast(attrs, [:slug, :title, :description, :body, :author_id])
    |> validate_required([:slug, :title, :description, :body])
    |> cast_assoc(:author)
    |> unique_constraint(:slug)
  end
end
