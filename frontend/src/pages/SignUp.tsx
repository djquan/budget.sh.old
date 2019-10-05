import React, { useState } from "react";
import gql from "graphql-tag";
import { useMutation } from "react-apollo";
import { useHistory } from "react-router-dom";
import { GET_CURRENT_USER_QUERY } from "../components/Header";

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

const SignUp = () => {
  const [state, setState] = useState({
    email: "",
    password: ""
  });

  const history = useHistory();

  const handleChange = (event: { target: { name: any; value: any; }; }) => {
    const { name, value } = event.target;
    setState({ ...state, ...{ [name]: value } });
  };

  const isFormValid = () => {
    return (
      state.email.length > 0 &&
      state.password.length > 0
    );
  };

  const [signUp, { loading: mutationLoading, error: mutationError }] = useMutation(
    SIGNUP_MUTATION,
    {
      update(cache, { data: { signup: { user } } }) {
        cache.writeQuery({
          query: GET_CURRENT_USER_QUERY,
          data: { me: user }
        });
      },
      onCompleted({ signup: { session } }) {
        localStorage.setItem("auth-token", session);
        history.push("/");
      },
    }
  )

  if (mutationLoading) return <Loading />;

  return (
    <form
      className="signup"
      onSubmit={e => {
        e.preventDefault();
        signUp({ variables: state });
      }}>

      {mutationError && <Error error={mutationError} />}

      <fieldset>
        <label htmlFor="email">Email</label>
        <input
          type="email"
          name="email"
          id="email"
          required
          value={state.email}
          onChange={handleChange}
        />
        <label htmlFor="password">Password</label>
        <input
          type="password"
          name="password"
          id="password"
          required
          value={state.password}
          onChange={handleChange}
        />
        <button type="submit" disabled={!isFormValid()}>
          Sign Up
        </button>
      </fieldset>
    </form>
  );
}

export default SignUp