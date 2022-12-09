defmodule Conduit.Repo.Migrations.AddedUserFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :bio, :string
      add :image, :string
    end
  end
end
