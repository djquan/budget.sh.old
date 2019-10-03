import React from "react";
import { useHistory } from "react-router";
import { NormalizedCacheObject } from "apollo-cache-inmemory";
import { ApolloClient } from "apollo-client";

const SignOut = ({ client }: { client: ApolloClient<NormalizedCacheObject> }) => {
  let history = useHistory();
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

export default SignOut;