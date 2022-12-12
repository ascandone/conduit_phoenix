defmodule Conduit.Blog.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias Conduit.Accounts.User
  alias Conduit.Blog.Article

  @timestamps_opts [type: :utc_datetime]
  @primary_key false
  schema "favorites" do
    belongs_to :user, User, primary_key: true
    belongs_to :article, Article, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:user_id, :article_id])
    |> validate_required([:user_id, :article_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:article_id)
    |> unique_constraint([:user, :article], name: :user_article_favorite_unique_index)
  end
end
