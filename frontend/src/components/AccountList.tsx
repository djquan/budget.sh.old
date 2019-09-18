import React, { Component, ReactNode, ReactElement } from "react";
import gql from "graphql-tag";
import { Query, QueryResult } from "react-apollo";
import PropTypes from "prop-types";
import Loading from "./Loading"
import Error from "./Error"
import { Account } from "../pages/Accounts"

const LIST_ACCOUNTS_QUERY = gql`
  query ListAccount {
    listAccounts {
      name
      public_id
    }
  }
`;

interface Props {
  children: (accounts: Account[]) => ReactElement<Account[]>
}

class AccountList extends Component<Props> {
  static propTypes = {
    children: PropTypes.func.isRequired
  };

  render(): ReactNode {
    return (
      <Query<Account[], {}> query={LIST_ACCOUNTS_QUERY}>
        {({ data, loading, error }: QueryResult) => {
          if (error) return Error(error)
          if (loading) return <Loading />
          return this.props.children(data.listAccounts)
        }}
      </Query>
    );
  }
}

export default AccountList;