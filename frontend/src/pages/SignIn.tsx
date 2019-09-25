import React, { Component } from "react";
import gql from "graphql-tag";
import { Mutation } from "react-apollo";
import { RouteComponentProps } from "react-router-dom";
import { GET_CURRENT_USER_QUERY } from "../components/Header";

import Error from "../components/Error"
import Loading from "../components/Loading"

const SIGNIN_MUTATION = gql`
  mutation SignIn($email: String!, $password: String!) {
    signin(email: $email, password: $password) {
      session
      user {
        email
      }
    }
  }
`;

class SignIn extends Component<RouteComponentProps> {
  state = {
    email: "",
    password: ""
  };

  handleChange = (event: { target: { name: any; value: any; }; }) => {
    const { name, value } = event.target;
    this.setState({ [name]: value });
  };

  isFormValid = () => {
    return (
      this.state.email.length > 0 &&
      this.state.password.length > 0
    );
  };

  handleCompleted = (data: { signin: { session: string; }; }) => {
    localStorage.setItem("auth-token", data.signin.session);

    this.props.history.push("/");
  };

  handleUpdate = (cache: { writeQuery: (arg0: { query: any; data: { me: any; }; }) => void; }, { data }: any) => {
    cache.writeQuery({
      query: GET_CURRENT_USER_QUERY,
      data: { me: data.signin.user }
    });
  };

  render(): React.ReactNode {
    return (
      <Mutation
        mutation={SIGNIN_MUTATION}
        variables={this.state}
        onCompleted={this.handleCompleted}
        update={this.handleUpdate}>
        {(signin: () => void, { loading, error }: any) => {
          if (loading) return <Loading />;

          return (
            <form
              className="signin"
              onSubmit={e => {
                e.preventDefault();
                signin();
              }}>
              <Error error={error} />
              <fieldset>
                <label htmlFor="email">Email</label>
                <input
                  type="email"
                  name="email"
                  id="email"
                  required
                  value={this.state.email}
                  onChange={this.handleChange}
                />
                <label htmlFor="password">Password</label>
                <input
                  type="password"
                  name="password"
                  id="password"
                  required
                  value={this.state.password}
                  onChange={this.handleChange}
                />
                <button type="submit" disabled={!this.isFormValid()}>
                  Sign In
                </button>
              </fieldset>
            </form>
          );
        }}
      </Mutation>
    );
  }
}

export default SignIn