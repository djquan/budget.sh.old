import React, { Component } from "react";
import { Link } from "react-router-dom";
import { Account } from "../pages/Accounts"

export interface Transaction {
  id: string,
  amount: string,
  transactionDate: string,
  type: string,
  credits: Transaction[],
  debits: Transaction[],
  account: Account
}

interface Props {
  transaction: Transaction
}

class TransactionRow extends Component<Props> {
  render(): React.ReactNode {
    const { transaction } = this.props;
    console.log(transaction)
    if (transaction.type == "CREDIT") {
      return (
        <div className="row">
          <div className="col-sm">{transaction.transactionDate}</div>
          <div className="col-sm"><a href={"/accounts/" + transaction.debits[0].account.id}>{transaction.debits[0].account.name}</a></div>
          <div className="col-sm">{transaction.amount}</div>
          <div className="col-sm"></div>
        </div>
      )
    }

    return (
      <div className="row">
        <div className="col-sm">{transaction.transactionDate}</div>
        <div className="col-sm"><a href={"/accounts/" + transaction.credits[0].account.id}>{transaction.credits[0].account.name}</a></div>
        <div className="col-sm"></div>
        <div className="col-sm">{transaction.amount}</div>
      </div>
    )
  }
}

export default TransactionRow;