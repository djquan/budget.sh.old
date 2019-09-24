import React, { Component } from "react";
import AccountSidebar from "../components/AccountSidebar";
import AccountDetail from "../components/AccountDetail"

interface Props {
  match: {
    params: {
      id: string
    }
  }
}

export interface Account {
  name: string,
  id: string,
  userAccount: boolean
}

class Accounts extends Component<Props> {
  render(): React.ReactNode {
    const { id } = this.props.match.params;
    return (
      <div className="d-flex" id="wrapper">
        <AccountSidebar />
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
                <AccountDetail id={id} />
              </>
            )}
          </div>
        </div>
      </div>
    );
  }
}

export default Accounts