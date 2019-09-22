import React, { Component, ReactNode } from "react";
import gql from "graphql-tag";
import { Query, QueryResult } from "react-apollo";
import Loading from "./Loading"
import Error from "./Error"
import { Account } from "../pages/Accounts"
import TransactionRow, { Transaction } from "./TransactionRow"
import TransactionCreate from "./TransactionCreate"

const GET_ACCOUNT_QUERY = gql`
  query GetAccount($id: String!) {
    getAccount(id: $id) {
      name
      id
      transactions {
        id
        amount
        type
        transactionDate
        credits {
          amount
          account {
            id
            name
          }
        }
        debits {
          amount
          account {
            id
            name
          }
        }
      }
    }
  }
`;

interface Props {
  id: string
}

class AccountDetail extends Component<Props> {
  render(): ReactNode {
    const { id } = this.props
    return (
      <Query<Account, {}> query={GET_ACCOUNT_QUERY} variables={{ id: id }} >
        {({ data, loading, error }: QueryResult) => {
          if (error) return Error(error)
          if (loading) return <Loading />
          const account = data.getAccount
          return (
            <>
              <h1 className="mt-4">{account.name}</h1><br /><br />
              <table className="table">
                <thead>
                  <tr>
                    <th scope="col-sm">Date</th>
                    <th scope="col-sm">From</th>
                    <th scope="col-sm">Credit</th>
                    <th scope="col-sm">Debit</th>
                    <th scope="col-sm"></th>
                  </tr>
                </thead>
                <tbody>
                  <TransactionCreate accountId={id} key={id} />
                  {account.transactions.map((transaction: Transaction) =>
                    <TransactionRow transaction={transaction} key={transaction.id} />
                  )}
                </tbody>
              </table>
            </>
          )
        }}
      </Query >
    );
  }
}

export default AccountDetail;