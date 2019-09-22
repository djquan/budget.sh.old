import React from "react";
import { NavLink } from "react-router-dom";
import CurrentUser from "./CurrentUser"
import SignOut from "./SignOut"

const Header: React.FC = () => (
  <header>
    <nav>
      <NavLink className="logo" to="/">
        <div>budget.sh</div>
      </NavLink>
      <CurrentUser>
        {currentUser => (
          <ul>
            {currentUser && (
              <>
                <li><NavLink to="/accounts">Accounts</NavLink></li>
                <li><SignOut /></li>
              </>
            )}
            {!currentUser && (
              <>
                <li><NavLink to="/sign-in">Sign In</NavLink></li>
                <li><NavLink to="/sign-up" className="button">Sign Up</NavLink></li>
              </>
            )}
          </ul>
        )}
      </CurrentUser>
    </nav>
  </header>
)

export default Header;