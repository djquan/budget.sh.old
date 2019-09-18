
import React, { Component } from "react";
import gql from "graphql-tag";
import { Query, QueryResult } from "react-apollo";
import PropTypes from "prop-types";
import Loading from "./Loading"
import Error from "./Error"

const LIST_ACCOUNTS_QUERY = gql`
  query ListAccount {
    listAccounts {
      name
      public_id
    }
  }
`;

export interface Props {
  children: any
}

class AccountList extends Component<Props> {
  static propTypes = {
    children: PropTypes.func.isRequired
  };

  render(): React.ReactNode {
    return (
      <Query query={LIST_ACCOUNTS_QUERY}>
        {({ data, loading, error }: QueryResult) => {
          if (error) return Error(error);
          if (loading) return <Loading />;
          return this.props.children(data.listAccounts);
        }}
      </Query>
    );
  }
}

export default AccountList;
export { LIST_ACCOUNTS_QUERY };