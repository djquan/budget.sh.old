import React, { Component } from "react";
import { withRouter, RouteComponentProps } from "react-router";
import { withApollo, WithApolloClient } from "react-apollo";

export interface State { }

type Props = WithApolloClient<RouteComponentProps>;

class SignOut extends Component<Props> {
  handleClick = () => {
    localStorage.removeItem("auth-token");
    this.props.client.resetStore();
    this.props.history.push("/");
  };

  render() {
    return (
      <button className="signout" onClick={this.handleClick}>
        Sign Out
            </button>
    );
  }
}

export default withRouter(withApollo<Props>(SignOut));