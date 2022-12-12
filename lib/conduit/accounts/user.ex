defmodule Conduit.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :username, :string
    field :bio, :string
    field :image, :string

    timestamps()
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        hashed_password = Argon2.hash_pwd_salt(password)
        put_change(changeset, :hashed_password, hashed_password)

      _ ->
        changeset
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :image, :bio])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_required([:username, :email])
    |> put_hashed_password()
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> validate_required([:password])
  end
end
