defmodule BudgetSH.AccountsTest do
  use BudgetSH.DataCase

  alias BudgetSH.Accounts

  alias BudgetSH.Accounts.User

  @valid_attrs %{password: "some password", email: "username@example.com"}
  @update_attrs %{password: "some updated password", email: "username@example.com"}
  @invalid_attrs %{password: nil, email: nil}
  @invalid_attrs_short_pw %{password: "abcdef", email: "username@example.com"}
  @invalid_attrs_non_email_username %{password: "abcdefgh", email: "not an email"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

    user
  end

  describe "list_users/0" do
    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end
  end

  describe "get_user!/1" do
    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end
  end

  describe "create_user/1" do
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.password_hash
      assert user.email == "username@example.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs_short_pw)

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs_non_email_username)
    end
  end

  describe "update_user/2" do
    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)

      assert user.password_hash
      assert user.email == "username@example.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs_short_pw)
      assert user == Accounts.get_user!(user.id)

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs_non_email_username)

      assert user == Accounts.get_user!(user.id)
    end
  end

  describe "delete_user/1" do
    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  describe "change_user/1" do
    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "authenticate/2" do
    @email "username@example.com"
    @password "hunter222"

    setup do
      {:ok, user: user_fixture(email: @email, password: @password)}
    end

    test "returns user if email/password valid" do
      assert {:ok, user} = Accounts.authenticate(@email, @password)
      assert %User{} = user
      assert user.email == @email
    end

    test "returns error if username doesn't match existing user" do
      assert {:error, "invalid user-identifier"} = Accounts.authenticate("bad_user", @password)
    end

    test "returns error if password invalid" do
      assert {:error, "invalid password"} = Accounts.authenticate(@email, "bad_password")
    end
  end
end
