defmodule Conduit.AccountsTest do
  use Conduit.DataCase

  import Conduit.AccountsFixtures
  alias Conduit.Accounts
  alias Conduit.Accounts.User

  describe "Accounts.register_user/1" do
    @invalid_attrs %{email: nil, password: nil, username: nil}
    @valid_attrs %{email: "email@example.com", password: "password", username: "uname"}

    test "with valid data inserts user" do
      {:ok, %User{} = user} = Accounts.register_user(@valid_attrs)

      assert user.email == @valid_attrs.email
      assert user.username == @valid_attrs.username
      assert user.hashed_password != @valid_attrs.password
      assert user.bio == nil
      assert user.image == nil

      # TODO check user is inserted
    end

    test "with invalid data returns error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.register_user(@invalid_attrs)
    end
  end

  describe "Accounts.authenticate_user/2" do
    @email "user@localhost"
    @password "123456"

    setup do
      {:ok, user: user_fixture(email: @email, password: @password)}
    end

    test "returns user when credentials are right", %{user: %User{id: id}} do
      assert {:ok, %User{id: ^id}} = Accounts.authenticate_user(@email, @password)
    end

    test "returns an error when user does not exist" do
      assert {:error, :not_found} = Accounts.authenticate_user("invalid-email", "password")
    end

    test "returns an error when password is not right" do
      assert {:error, :wrong_password} = Accounts.authenticate_user(@email, "invalid password")
    end
  end

  test "Accounts.get_user_by_username/1" do
    %User{username: username} = user_fixture()
    assert %User{username: ^username} = Accounts.get_user_by_username(username)
  end

  test "Accounts.update_user/2" do
    user = user_fixture()

    attrs = %{
      bio: "new bio",
      username: "new-username"
    }

    new_user = Accounts.update_user(user, attrs)

    assert new_user.id == user.id
    assert new_user.email == user.email
    assert new_user.image == user.image

    assert new_user.username == attrs.username
    assert new_user.bio == attrs.bio

    new_user = Accounts.get_user_by_id(user.id)
    assert new_user.username == attrs.username
  end
end
