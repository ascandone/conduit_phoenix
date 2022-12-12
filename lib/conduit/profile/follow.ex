defmodule Conduit.Profile.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  alias Conduit.Accounts.User

  @timestamps_opts [type: :utc_datetime]
  @primary_key false
  schema "follows" do
    belongs_to :user, User, primary_key: true
    belongs_to :target, User, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:user_id, :target_id])
    |> validate_required([:user_id, :target_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:target_id)
    |> unique_constraint([:user, :target], name: :user_target_unique_index)
  end
end
