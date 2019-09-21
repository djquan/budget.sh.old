import React, { Component } from "react";
import { Link } from "react-router-dom";
import { Account } from "../pages/Accounts"

export interface Transaction {
  id: String,
  amount: String,
}

interface Props {
  transaction: Transaction
}

class TransactionRow extends Component<Props> {
  render(): React.ReactNode {
    const { transaction } = this.props;
    return (
      <div className="row">
        <div className="col-sm">{transaction.amount}</div>
      </div>
    )
  }
}

export default TransactionRow;