import React, { useState } from "react";
import gql from "graphql-tag";
import { useMutation } from "react-apollo";
import { useHistory } from "react-router-dom";
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

const SignIn = () => {
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

  const [signIn, { loading: mutationLoading, error: mutationError }] = useMutation(
    SIGNIN_MUTATION,
    {
      update(cache, { data: { signin: { user } } }) {
        cache.writeQuery({
          query: GET_CURRENT_USER_QUERY,
          data: { me: user }
        });
      },
      onCompleted({ signin: { session } }) {
        localStorage.setItem("auth-token", session);
        history.push("/");
      },
    }
  )

  if (mutationLoading) return <Loading />;

  return (
    <form
      className="signin"
      onSubmit={e => {
        e.preventDefault();
        signIn({ variables: state });
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
          Sign In
        </button>
      </fieldset>
    </form>
  );
}

export default SignIn