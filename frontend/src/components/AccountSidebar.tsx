import React, { Component } from "react";
import { Link } from "react-router-dom";
import { Account } from "../pages/Accounts"

interface Props {
  accounts: Account[]
}

class AccountSidebar extends Component<Props> {
  render(): React.ReactNode {
    const accountList = this.props.accounts
    return (
      <div className="bg-light border-right" id="sidebar-wrapper">
        <div className="sidebar-heading">Accounts</div>
        <div className="list-group list-group-flush">
          {accountList.map((account: Account) =>
            <Link
              className="list-group-item list-group-item-action bg-light"
              to={"/accounts/" + account.id}
              key={account.id} >
              {account.name}
            </Link>
          )}
        </div>
      </div>
    )
  }
}

export default AccountSidebar;