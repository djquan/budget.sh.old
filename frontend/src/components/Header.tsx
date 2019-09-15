import React from "react";
import { NavLink } from "react-router-dom";
import CurrentUser from "./CurrentUser"
import SignOut from "./SignOut"

const Header: React.FC = () => (
  <CurrentUser>
    {currentUser => (
      <header>
        <nav>
          <NavLink className="logo" to="/">
            <div>budget.sh</div>
          </NavLink>
          <ul>
            {currentUser && (
              <>
                <li><SignOut /></li>
                <li className="user"><i className="far fa-user" />
                  {currentUser.email}
                </li>
              </>
            )}
            {!currentUser && (
              <>
                <li><NavLink to="/sign-in">Sign In</NavLink></li>
                <li><NavLink to="/sign-up" className="button">Sign Up</NavLink></li>
              </>
            )}
          </ul>
        </nav>
      </header >)}
  </CurrentUser>
)

export default Header;