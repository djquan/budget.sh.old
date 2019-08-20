defmodule BudgetSH.FinanceTest do
  use BudgetSH.DataCase

  alias BudgetSH.Finance
  alias BudgetSH.Finance.Account
  alias BudgetSH.Finance.Transaction
  alias BudgetSH.Repo

  @valid_account_attrs %{name: "some name"}
  @update_account_attrs %{name: "some updated name"}
  @invalid_account_attrs %{name: nil}

  @valid_user_attrs %{password: "some password", email: "username@example.com"}

  @valid_transaction_attrs %{
    amount: "100",
    currency_code: "USD",
    transaction_date: Date.utc_today(),
    tags: ["apple"]
  }

  def account_fixture(attrs \\ %{}, user_attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@valid_account_attrs)
      |> Finance.create_account(user_fixture(user_attrs))

    account
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> BudgetSH.Accounts.create_user()

    user
  end

  def transaction_fixture(attrs \\ %{}, account_attrs \\ %{}, user_attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(@valid_transaction_attrs)
      |> Finance.create_transaction(account_fixture(account_attrs, user_attrs))

    transaction
  end

  describe "accounts" do
    test "list_accounts/1 returns all accounts" do
      _bad_account =
        account_fixture(@valid_account_attrs, %{email: "hi@hi.com", password: "hunter2"})

      account = account_fixture()

      list =
        Finance.list_accounts(account.user)
        |> Enum.map(fn acct -> Repo.preload(acct, :user) end)

      assert list == [account]
    end

    test "get_account!/2 returns the account with given id" do
      account = account_fixture()

      assert Finance.get_account!(account.id, account.user)
             |> Repo.preload(:user) == account
    end

    test "get_account!/2 raises an exception if the account is correct but the user is not" do
      account = account_fixture()
      bad_user = user_fixture(%{email: "hi@aol.com", password: "hunter2"})

      assert_raise Ecto.NoResultsError, fn -> Finance.get_account!(account.id, bad_user) end
    end

    test "create_account/2 with valid data creates a account" do
      user = user_fixture()
      assert {:ok, %Account{} = account} = Finance.create_account(@valid_account_attrs, user)
      account = Repo.preload(account, :user)
      assert account.name == "some name"
      assert account.user == user
    end

    test "create_account/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Finance.create_account(@invalid_account_attrs, user_fixture())
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      public_id = account.public_id
      assert {:ok, %Account{} = account} = Finance.update_account(account, @update_account_attrs)
      assert account.name == "some updated name"
      assert account.public_id == public_id
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_account(account, @invalid_account_attrs)
      assert account == Finance.get_account!(account.id, account.user) |> Repo.preload(:user)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Finance.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_account!(account.id, account.user) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Finance.change_account(account)
    end
  end

  describe "transactions" do
    # test "list_transactions/1 returns all transactions from a user" do
    #   transaction = transaction_fixture()
    # end

    # test "list_transactions/2 returns all transactions from a user and account"

    test "create_transaction/2 creates a transaction for a user and account" do
      account = account_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Finance.create_transaction(@valid_transaction_attrs, account)

      transaction = Repo.preload(transaction, :account)
      assert transaction.amount == "100"
      assert transaction.account == account
    end

    # test "update_transaction/2 with valid data"
    # test "update_transaction/2 with invalid datta"

    # test "delete_transaction/1"
    # test "change_transaction/1 returns a transaction changeset"
  end
end
