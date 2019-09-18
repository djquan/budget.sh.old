import React, { Component } from "react";
import gql from "graphql-tag";
import { Mutation } from "react-apollo";
import { RouteComponentProps } from "react-router-dom";
import { GET_CURRENT_USER_QUERY } from "../components/CurrentUser";

import Error from "../components/Error"
import Loading from "../components/Loading"

const SIGNUP_MUTATION = gql`
  mutation SignUp($email: String!, $password: String!) {
    signup(email: $email, password: $password) {
      session
      user {
        email
      }
    }
  }
`;

class SignUp extends Component<RouteComponentProps> {
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

  handleCompleted = (data: { signup: { session: string; }; }) => {
    localStorage.setItem("auth-token", data.signup.session);

    this.props.history.push("/");
  };

  handleUpdate = (cache: { writeQuery: (arg0: { query: any; data: { me: any; }; }) => void; }, { data }: any) => {
    cache.writeQuery({
      query: GET_CURRENT_USER_QUERY,
      data: { me: data.signup.user }
    });
  };

  render(): React.ReactNode {
    return (
      <Mutation
        mutation={SIGNUP_MUTATION}
        variables={this.state}
        onCompleted={this.handleCompleted}
        update={this.handleUpdate}>
        {(signup: () => void, { loading, error }: any) => {
          if (loading) return <Loading />;

          return (
            <form
              className="signup"
              onSubmit={e => {
                e.preventDefault();
                signup();
              }}>
              {Error(error)}
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
                  Sign Up
                </button>
              </fieldset>
            </form>
          );
        }}
      </Mutation>
    );
  }
}

export default SignUp