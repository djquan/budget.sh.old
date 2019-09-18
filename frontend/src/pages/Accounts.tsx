import React, { Component } from "react";
import AccountSidebar from "../components/AccountSidebar";
import AccountList from "../components/AccountList"

interface Props {
  match: {
    params: {
      public_id: string
    }
  }
}

export interface Account {
  name: string,
  public_id: string
}

class Accounts extends Component<Props> {
  render(): React.ReactNode {
    const { public_id } = this.props.match.params;
    return (
      <AccountList>
        {(accountList: Account[]) => (
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