defmodule Conduit.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :target_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:follows, [:user_id, :target_id], name: :user_id_target_id_index)
  end
end
