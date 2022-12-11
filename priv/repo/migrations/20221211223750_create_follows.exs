defmodule Conduit.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :target_id, references(:users, on_delete: :nothing), primary_key: true

      timestamps()
    end

    create unique_index(:follows, [:user_id, :target_id], name: :user_target_unique_index)
  end
end
