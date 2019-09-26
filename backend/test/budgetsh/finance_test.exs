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
    tags: ["apple"],
    type: :credit
  }
  @invalid_transaction_attrs %{amount: "ABC", currency_code: "TEST", type: :not_real}
  @update_transaction_attrs %{
    amount: "1"
  }

  def account_fixture_for_user(user, attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@valid_account_attrs)
      |> Finance.create_account(user)

    account
  end

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
    account = account_fixture(account_attrs, user_attrs)

    attrs =
      attrs
      |> Enum.into(@valid_transaction_attrs)
      |> Map.put(:account_id, account.id)

    {:ok, transaction} = Finance.create_transactions([attrs], account.user)
    transaction |> Repo.preload(account: :user)
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

    test "get_account/2 returns the account with given id" do
      account = account_fixture()

      assert Finance.get_account(account.id, account.user)
             |> Repo.preload(:user) == account
    end

    test "get_account/2 raises an exception if the account is correct but the user is not" do
      account = account_fixture()
      bad_user = user_fixture(%{email: "hi@aol.com", password: "hunter2"})

      assert Finance.get_account(account.id, bad_user) == nil
    end

    test "create_account/2 with valid data creates a account" do
      user = user_fixture()
      assert {:ok, %Account{} = account} = Finance.create_account(@valid_account_attrs, user)
      account = Repo.preload(account, :user)
      assert account.name == "some name"
      assert account.user == user
      assert account.id
    end

    test "create_account/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Finance.create_account(@invalid_account_attrs, user_fixture())
    end

    test "create_account/2 with duplicate names but the same user returns error changeset" do
      user = user_fixture()
      assert {:ok, %Account{}} = Finance.create_account(@valid_account_attrs, user)

      assert {:error, %Ecto.Changeset{}} = Finance.create_account(@valid_account_attrs, user)
    end

    test "create_account/2 with duplicate names is case insensitive" do
      user = user_fixture()
      assert {:ok, %Account{}} = Finance.create_account(%{name: "test"}, user)
      assert {:error, %Ecto.Changeset{}} = Finance.create_account(%{name: "TEST"}, user)
    end

    test "create_account/2 with duplicate name but different user returns ok" do
      user = user_fixture()
      assert {:ok, %Account{}} = Finance.create_account(@valid_account_attrs, user)

      user2 = user_fixture(%{email: "test@example.com"})
      assert {:ok, %Account{}} = Finance.create_account(@valid_account_attrs, user2)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      id = account.id
      assert {:ok, %Account{} = account} = Finance.update_account(account, @update_account_attrs)
      assert account.name == "some updated name"
      assert account.id == id
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_account(account, @invalid_account_attrs)

      assert account == Finance.get_account(account.id, account.user) |> Repo.preload(:user)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Finance.delete_account(account)

      assert Finance.get_account(account.id, account.user) == nil
    end
  end

  describe "transactions" do
    test "list_transactions/2 returns all transactions from a account" do
      transaction = transaction_fixture()

      _bad_transacton =
        transaction_fixture(@valid_transaction_attrs, @valid_account_attrs, %{
          email: "test@example.org",
          password: "hunter3"
        })

      assert [transaction] = Finance.list_transactions(transaction.account)
    end

    test "create_transactions/2 creates a transaction" do
      account = account_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Finance.create_transactions(
                 [
                   Map.put(@valid_transaction_attrs, :account_id, account.id)
                 ],
                 account.user
               )

      transaction = Repo.preload(transaction, account: :user)
      assert transaction.amount == "100"
      assert transaction.account == account
    end

    test "create_transactions/2 fails if the account does not exist" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Finance.create_transactions(
                 [
                   Map.put(@valid_transaction_attrs, :account_id, Ecto.UUID.generate())
                 ],
                 user_fixture()
               )

      assert [
               account_id: {"Could not find account id", []}
             ] = changeset.errors
    end

    test "create_transactions/2 creates a transaction with linked transactions" do
      user = user_fixture()
      visa = account_fixture_for_user(user, %{name: "Visa", user_account: true})
      chipotle = account_fixture_for_user(user, %{name: "Chiptole"})

      assert {:ok, %Transaction{} = transaction} =
               Finance.create_transactions(
                 [
                   Map.put(%{@valid_transaction_attrs | type: :credit}, :account_id, visa.id),
                   Map.put(%{@valid_transaction_attrs | type: :debit}, :account_id, chipotle.id)
                 ],
                 user
               )

      transaction = Repo.preload(transaction, [:debits, :credits, account: :user])
      assert transaction.amount == "100"
      assert transaction.account == visa
      assert length(transaction.debits) == 1
      assert length(transaction.credits) == 0
    end

    test "create_transactions/2 with invalid data returns error changeset" do
      account = account_fixture()

      assert {:error, changeset = %Ecto.Changeset{}} =
               Finance.create_transactions(
                 [
                   Map.put(@invalid_transaction_attrs, :account_id, account.id)
                 ],
                 account.user
               )

      assert [
               amount: {"must be numeric", [validation: :format]},
               transaction_date: {"can't be blank", [validation: :required]},
               type:
                 {"is invalid",
                  [
                    type: BudgetSH.Finance.Transaction.TransactionTypeEnum,
                    validation: :cast
                  ]}
             ] = changeset.errors
    end

    test "create_transactions/2 returns an error if the user does not match the account" do
      user = user_fixture()
      visa = account_fixture_for_user(user, %{name: "Visa", user_account: true})
      wrong_user = user_fixture(%{email: "wrong@wrong.com"})

      assert {:error, changeset = %Ecto.Changeset{}} =
               Finance.create_transactions(
                 [
                   Map.put(@valid_transaction_attrs, :account_id, visa.id)
                 ],
                 wrong_user
               )

      assert [
               account_id: {"Could not find account id", []}
             ] = changeset.errors
    end

    test "get_transaction/2 returns an existing transaction" do
      transaction = transaction_fixture()

      assert transaction = Finance.get_transaction!(transaction.id, transaction.account)
    end

    test "get_transaction/2 returns an exception when the transaction id is right but the account is not" do
      transaction = transaction_fixture()

      bad_account =
        account_fixture(@valid_account_attrs, %{email: "test@example.org", password: "hunter3"})

      assert_raise Ecto.NoResultsError, fn ->
        Finance.get_transaction!(transaction.id, bad_account)
      end
    end

    test "get_transaction/2 returns an exception when the transaction id does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Finance.get_transaction!(Ecto.UUID.generate(), account_fixture())
      end
    end

    test "update_transaction/2 with valid data" do
      transaction = transaction_fixture()
      id = transaction.id

      assert {:ok, %Transaction{} = transaction} =
               Finance.update_transaction(transaction, @update_transaction_attrs)

      assert transaction.amount == "1"
      assert transaction.id == id

      assert transaction ==
               Finance.get_transaction!(transaction.id, transaction.account)
               |> Repo.preload(account: :user)
    end

    test "update_transaction/2 with invalid data" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Finance.update_transaction(transaction, @invalid_transaction_attrs)

      assert transaction ==
               Finance.get_transaction!(transaction.id, transaction.account)
               |> Repo.preload(account: :user)
    end

    test "delete_transaction/1" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Finance.delete_transaction(transaction)

      assert_raise Ecto.NoResultsError, fn ->
        Finance.get_transaction!(transaction.id, transaction.account)
      end
    end
  end
end
