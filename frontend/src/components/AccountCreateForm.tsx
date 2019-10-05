import React, { useState, ChangeEvent } from "react";
import gql from "graphql-tag";
import { useMutation } from "react-apollo";
import { LIST_ACCOUNTS_QUERY } from "./AccountSidebar"
import Error from "../components/Error"

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

const AccountCreateForm = ({ onCreate }: { onCreate: (creating: boolean) => void }) => {
  const [accountName, setAccountName] = useState("");

  const handleChange = (event: ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;
    if (name === "AccountName") setAccountName(value);
  }

  const [createAccount, { error: mutationError }] = useMutation(
    ACCOUNT_CREATE_MUTATION,
    {
      update(cache, { data: { createAccount } }) {
        const { listAccounts } = cache.readQuery<AllTasksResult>({ query: LIST_ACCOUNTS_QUERY })!;
        cache.writeQuery({
          query: LIST_ACCOUNTS_QUERY,
          data: { listAccounts: listAccounts.concat([createAccount]) },
        });
        setAccountName("")
        onCreate(false)
      }
    }
  )

  const submit = () => {
    createAccount({ variables: { name: accountName } })
  }

  return (
    <>
      <div className="input-group mb-3">
        <input
          name="AccountName"
          className="form-control"
          type="text"
          placeholder="Create Account"
          value={accountName}
          onChange={handleChange}
          onBlur={submit}
          onKeyDown={({ key }) => {
            if (key === 'Enter') {
              submit();
            }
          }}
        />
        {mutationError && <Error error={mutationError} />}
      </div>
    </>
  )
}

export default AccountCreateForm