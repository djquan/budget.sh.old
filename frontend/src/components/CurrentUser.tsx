import React, { Component, ReactElement } from "react";
import gql from "graphql-tag";
import { Query, QueryResult } from "react-apollo";
import PropTypes from "prop-types";
import Loading from "./Loading"

const GET_CURRENT_USER_QUERY = gql`
  query GetCurrentUser {
    me {
      email
    }
  }
`;

interface me {
  email?: string
}

interface Props {
  children: (me: me) => ReactElement<me>
}

class CurrentUser extends Component<Props> {
  static propTypes = {
    children: PropTypes.func.isRequired
  };

  render(): React.ReactNode {
    return (
      <Query query={GET_CURRENT_USER_QUERY}>
        {({ data, loading, error }: QueryResult) => {
          if (error) return this.props.children({});
          if (loading) return <Loading />;
          return this.props.children(data.me);
        }}
      </Query>
    );
  }
}

export default CurrentUser;
export { GET_CURRENT_USER_QUERY };