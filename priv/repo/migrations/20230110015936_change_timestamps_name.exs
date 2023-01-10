defmodule Conduit.Repo.Migrations.ChangeTimestampsName do
  use Ecto.Migration

  def change do
    rename table(:users), :inserted_at, to: :created_at
    rename table(:articles), :inserted_at, to: :created_at
    rename table(:comments), :inserted_at, to: :created_at
    rename table(:favorites), :inserted_at, to: :created_at
    rename table(:follows), :inserted_at, to: :created_at
  end
end
