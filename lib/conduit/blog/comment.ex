defmodule Conduit.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime, inserted_at: :created_at]
  schema "comments" do
    field :body, :string

    belongs_to :author, Conduit.Accounts.User
    belongs_to :article, Conduit.Blog.Article

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:body, :author_id, :article_id])
    |> validate_required([:body, :author_id, :article_id])
    |> cast_assoc(:author)
  end
end
