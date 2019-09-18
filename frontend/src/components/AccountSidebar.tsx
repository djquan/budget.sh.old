import React, { Component } from "react";
import { Link } from "react-router-dom";

export interface Props {
  accounts: any
}

class AccountSidebar extends Component<Props> {
  render(): React.ReactNode {
    const accountList = this.props.accounts
    return (
      <div className="bg-light border-right" id="sidebar-wrapper">
        <div className="sidebar-heading">Accounts</div>
        <div className="list-group list-group-flush">
          {accountList.map((account: any) =>
            <Link
              className="list-group-item list-group-item-action bg-light"
              to={"/accounts/" + account.public_id}
              key={account.public_id} >
              {account.name}
            </Link>
          )}
        </div>
      </div>
    )
  }
}

export default AccountSidebar;