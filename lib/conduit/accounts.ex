defmodule Conduit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Conduit.Repo

  alias Conduit.Accounts.User

  @doc """
  Register a new user

  ## Examples

      iex> register_user(%{
          username: "valid-username",
          email: "email@example.com",
          password: "valid-pasword"
        })

      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Authenticate an user using email and password
  """
  def authenticate_user(email, password) do
    user = Repo.one(from u in User, where: u.email == ^email)

    cond do
      user == nil ->
        {:error, :not_found}

      Argon2.verify_pass(password, user.hashed_password) ->
        {:ok, user}

      true ->
        {:error, :wrong_password}
    end
  end

  def get_user_by_id(id) do
    Repo.get(User, id)
  end

  def get_user_by_username(username) do
    Repo.one(from u in User, where: u.username == ^username)
  end

  defp preload_following(%User{} = user, nil) do
    user
  end

  defp preload_following(%User{} = user, %User{} = viewer) do
    %{user | following: Conduit.Profile.following?(viewer, user)}
  end

  def user_preload(nil, _) do
    nil
  end

  def user_preload(%User{} = user, viewer) do
    preload_following(user, viewer)
  end
end
