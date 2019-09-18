import React, { Component } from "react";
import AccountSidebar from "../components/AccountSidebar";
import AccountList from "../components/AccountList"
import { NavLink } from "react-router-dom";

export interface Props {
  match: any
}

class Accounts extends Component<Props> {
  render(): React.ReactNode {
    const { public_id } = this.props.match.params;
    return (
      <AccountList>
        {accountList => (
          <div>
            {accountList && (
              <>
                <div className="d-flex" id="wrapper">
                  <AccountSidebar accounts={accountList} />
                  <div id="page-content-wrapper">
                    <div className="container-fluid">
                      {!public_id && (
                        <>
                          <h1 className="mt-4">All Accounts</h1>
                          <p>{public_id}</p>
                        </>
                      )}
                      {public_id && (
                        <>
                          <h1 className="mt-4">{public_id}</h1>
                          <p>{public_id}</p>
                        </>
                      )}
                    </div>
                  </div>
                </div>
              </>
            )}
            {!accountList && (
              <></>
            )}
          </div >)}
      </AccountList>
    );
  }
}

export default Accounts