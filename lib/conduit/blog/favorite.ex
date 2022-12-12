defmodule Conduit.Blog.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias Conduit.Accounts.User
  alias Conduit.Blog.Article

  @primary_key false
  schema "follows" do
    belongs_to :user, User, primary_key: true
    belongs_to :target, Article, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:user_id, :target_id])
    |> validate_required([:user_id, :target_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:target_id)
    |> unique_constraint([:user, :target], name: :user_target_favorite_unique_index)
  end
end
