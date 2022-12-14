defmodule Conduit.Repo.Migrations.AddArticleFavorite do
  use Ecto.Migration

  def change do
    create table(:favorites, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:favorites, [:user_id, :article_id],
             name: :user_article_favorite_unique_index
           )
  end
end
