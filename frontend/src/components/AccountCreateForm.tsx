import React, { useState, ChangeEvent } from "react";
import gql from "graphql-tag";
import { useMutation } from "react-apollo";
import { LIST_ACCOUNTS_QUERY } from "./AccountSidebar"

const ACCOUNT_CREATE_MUTATION = gql`
  mutation CreateAccount($name: String!) {
    createAccount(name: $name, userAccount: true) {
      id
      name
      userAccount
    }
  }
`;

interface AllTasksResult {
  listAccounts: Account[]
}

const AccountCreateForm = () => {
  const [accountName, setAccountName] = useState("");

  const handleChange = (event: ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;
    if (name === "AccountName") setAccountName(value);
  }

  const [createAccount] = useMutation(
    ACCOUNT_CREATE_MUTATION,
    {
      update(cache, { data: { createAccount } }) {
        const { listAccounts } = cache.readQuery<AllTasksResult>({ query: LIST_ACCOUNTS_QUERY })!;
        cache.writeQuery({
          query: LIST_ACCOUNTS_QUERY,
          data: { listAccounts: listAccounts.concat([createAccount]) },
        });
        setAccountName("")
      }
    }
  )

  const submit = () => {
    createAccount({ variables: { name: accountName } })
  }

  return (
    <>
      <input
        name="AccountName"
        type="text"
        placeholder="create account"
        value={accountName}
        onChange={handleChange}
        onBlur={submit}
      />
    </>
  )
}

export default AccountCreateForm