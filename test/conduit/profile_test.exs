defmodule Conduit.ProfileTest do
  use Conduit.DataCase
  import Conduit.AccountsFixtures

  alias Conduit.Profile
  alias Conduit.Profile.Follow

  test "following?/2 should return false if an user is not following another" do
    user = user_fixture()
    target = user_fixture()

    assert Profile.following?(user, target) == false
  end

  test "follow/2 should make a user follow another" do
    user = user_fixture()
    target = user_fixture()

    assert {:ok, %Follow{} = follow} = Profile.follow(user, target)
    assert user.id == follow.user_id
    assert target.id == follow.target_id
  end

  test "following?/2 should return true after calling follow/2" do
    user = user_fixture()
    target = user_fixture()

    Profile.follow(user, target)
    assert Profile.following?(user, target)
  end

  test "following?/2 should return false after calling unfollow/2" do
    user = user_fixture()
    target = user_fixture()

    Profile.follow(user, target)
    assert {:ok, _} = Profile.unfollow(user, target)
    assert Profile.following?(user, target) == false
  end

  test "unfollow?/2 should return nil if the is not following the target" do
    user = user_fixture()
    target = user_fixture()

    assert Profile.unfollow(user, target) == nil
  end

  @tag :skip
  test "follow/2 should return error when called twice" do
    user = user_fixture()
    target = user_fixture()

    Profile.follow(user, target)
    assert {:error, %Ecto.Changeset{}} = Profile.follow(user, target)
  end
end
