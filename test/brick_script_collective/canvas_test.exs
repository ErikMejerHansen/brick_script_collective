defmodule BrickScriptCollective.CanvasTest do
  use BrickScriptCollective.DataCase

  alias BrickScriptCollective.Canvas

  describe "userss" do
    alias BrickScriptCollective.Canvas.User

    import BrickScriptCollective.CanvasFixtures

    @invalid_attrs %{foo: nil}

    test "list_userss/0 returns all userss" do
      user = user_fixture()
      assert Canvas.list_userss() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Canvas.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{foo: "some foo"}

      assert {:ok, %User{} = user} = Canvas.create_user(valid_attrs)
      assert user.foo == "some foo"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canvas.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{foo: "some updated foo"}

      assert {:ok, %User{} = user} = Canvas.update_user(user, update_attrs)
      assert user.foo == "some updated foo"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Canvas.update_user(user, @invalid_attrs)
      assert user == Canvas.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Canvas.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Canvas.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Canvas.change_user(user)
    end
  end
end
