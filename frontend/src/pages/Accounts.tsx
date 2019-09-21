import React, { Component } from "react";
import AccountSidebar from "../components/AccountSidebar";
import AccountList from "../components/AccountList"

interface Props {
  match: {
    params: {
      id: string
    }
  }
}

export interface Account {
  name: string,
  id: string
}

class Accounts extends Component<Props> {
  render(): React.ReactNode {
    const { id } = this.props.match.params;
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
                      {!id && (
                        <>
                          <h1 className="mt-4">All Accounts</h1>
                          <p>{id}</p>
                        </>
                      )}
                      {id && (
                        <>
                          <h1 className="mt-4">{id}</h1>
                          <p>{id}</p>
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