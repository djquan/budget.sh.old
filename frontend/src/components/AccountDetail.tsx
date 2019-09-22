import React, { Component, ReactNode } from "react";
import gql from "graphql-tag";
import { Query, QueryResult } from "react-apollo";
import Loading from "./Loading"
import Error from "./Error"
import { Account } from "../pages/Accounts"
import TransactionRow, { Transaction } from "./TransactionRow"

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
            name
          }
        }
        debits {
          amount
          account {
            name
          }
        }
      }
    }
  }
`;

interface Props {
  id: String
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
              <h1 className="mt-4">{account.name}</h1>
              <div className="transaction-grid">
                <div className="row">
                  <div className="col-sm">Date</div>
                  <div className="col-sm">From</div>
                  <div className="col-sm">Credit</div>
                  <div className="col-sm">Debit</div>
                </div>
                {account.transactions.map((transaction: Transaction) =>
                  <div key={transaction.id}>
                    <TransactionRow transaction={transaction} />
                  </div>
                )}
              </div>
            </>
          )
        }}
      </Query >
    );
  }
}

export default AccountDetail;