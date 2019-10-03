import React from "react";
import { NavLink } from "react-router-dom";
import SignOut from "./SignOut"
import { useQuery } from "react-apollo";
import gql from "graphql-tag";
import Loading from "./Loading"

export const GET_CURRENT_USER_QUERY = gql`
  query GetCurrentUser {
    me {
      email
    }
  }
`;

const Header: React.FC = () => {
  const { client, loading, data } = useQuery(GET_CURRENT_USER_QUERY);
  return (
    <header>
      <nav>
        <NavLink className="logo" to="/">
          <div>budget.sh</div>
        </NavLink>
        {loading && (<Loading />)}
        <ul>
          {data && data.me && (
            <>
              <li><NavLink to="/accounts">Accounts</NavLink></li>
              <li><SignOut client={client} /></li>
            </>
          )}
          {(!data || !data.me) && (
            <>
              <li><NavLink to="/sign-in">Sign In</NavLink></li>
              <li><NavLink to="/sign-up" className="button">Sign Up</NavLink></li>
            </>
          )}
        </ul>
      </nav>
    </header>
  )
}

export default Header;