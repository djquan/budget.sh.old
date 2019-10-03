import React from "react";
import { withRouter, RouteComponentProps, useHistory } from "react-router";
import { withApollo, WithApolloClient, useQuery } from "react-apollo";
import { GET_CURRENT_USER_QUERY } from "./Header";

type Props = WithApolloClient<RouteComponentProps>;

const SignOut = () => {
  let history = useHistory();
  const { client } = useQuery(GET_CURRENT_USER_QUERY);

  const handleClick = () => {
    client.resetStore();
    localStorage.removeItem("auth-token");
    history.push("/")
  }

  return (
    <button className="signout" onClick={handleClick}>
      Sign Out
    </button>
  );
}

export default withRouter(withApollo<Props>(SignOut));