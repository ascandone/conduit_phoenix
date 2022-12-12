defmodule Conduit.Repo.Migrations.AddArticleFavorite do
  use Ecto.Migration

  def change do
    create table(:favorite, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :target_id, references(:articles, on_delete: :nothing), primary_key: true

      timestamps()
    end

    create unique_index(:favorite, [:user_id, :target_id],
             name: :user_target_favorite_unique_index
           )
  end
end
