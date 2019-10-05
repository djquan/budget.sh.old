import React from "react";
import { Account } from "../pages/Accounts"

export interface Transaction {
  id: string,
  amount: number,
  transactionDate: string,
  type: string,
  credits: Transaction[],
  debits: Transaction[],
  account: Account
}

const formatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  minimumFractionDigits: 2
})

const TransactionRow = ({ transaction }: { transaction: Transaction }) => {
  if (transaction.type === "CREDIT") {
    return (
      <tr key={transaction.id}>
        <th scope="row">{transaction.transactionDate}</th>
        <td><a href={"/accounts/" + transaction.debits[0].account.id}>{transaction.debits[0].account.name}</a></td>
        <td>{formatter.format(transaction.amount / 100)}</td>
        <td></td>
        <td></td>
      </tr>
    )
  }

  return (
    <tr key={transaction.id}>
      <th scope="row">{transaction.transactionDate}</th>
      <td><a href={"/accounts/" + transaction.credits[0].account.id}>{transaction.credits[0].account.name}</a></td>
      <td></td>
      <td>{formatter.format(transaction.amount / 100)}</td>
      <td></td>
    </tr>
  )
}

export default TransactionRow;