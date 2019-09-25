import React from "react";
import { Link } from "react-router-dom";
import { Account } from "../pages/Accounts"
import { useQuery } from "react-apollo";
import gql from "graphql-tag";
import Loading from "./Loading"
import Error from "./Error"
import AccountCreateForm from "./AccountCreateForm"

export const LIST_ACCOUNTS_QUERY = gql`
  query ListAccount {
    listAccounts {
      name
      id
      userAccount
    }
  }
`;

const AccountSidebar: React.FC = () => {
  const { loading, data, error } = useQuery(LIST_ACCOUNTS_QUERY);
  if (error) return <Error error={error} />
  if (loading) return <Loading />
  return (
    <div className="bg-light border-right" id="sidebar-wrapper">
      <div className="sidebar-heading">Accounts</div>
      <div className="list-group list-group-flush">
        {
          data.listAccounts
            .filter((account: Account) => account.userAccount === true)
            .map((account: Account) =>
              <Link
                className="list-group-item list-group-item-action bg-light"
                to={"/accounts/" + account.id}
                key={account.id} >
                {account.name}
              </Link>
            )
        }<br />
        <AccountCreateForm />
      </div>
    </div>
  )
}

export default AccountSidebar;