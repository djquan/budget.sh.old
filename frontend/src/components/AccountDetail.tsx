import React, { useState } from "react";
import gql from "graphql-tag";
import Loading from "./Loading"
import Error from "./Error"
import TransactionRow, { Transaction } from "./TransactionRow"
import TransactionCreate from "./TransactionCreate"
import { useQuery } from "react-apollo";
import { useHistory } from "react-router";
import Button from "react-bootstrap/Button";

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

const AccountDetail = ({ id }: { id: string }) => {
  const { loading, data, error } = useQuery(GET_ACCOUNT_QUERY, { variables: { id: id } });
  const [showTransactionCreate, setShowTransactionCreate] = useState(false);
  if (error) return <Error error={error} />
  if (loading) return <Loading />
  const account = data.getAccount

  return (
    <>
      <h1 className="mt-4">{account.name}</h1>
      <Button
        key={id}
        variant="primary"
        onClick={() => {
          setShowTransactionCreate(!showTransactionCreate);
        }}>
        {!showTransactionCreate && "Create Transaction"}
        {showTransactionCreate && "Hide Create Transaction"}
      </Button>
      <br /><br />
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
          {showTransactionCreate && <TransactionCreate accountId={id} key={id} />}
          {account.transactions.map((transaction: Transaction) =>
            <TransactionRow transaction={transaction} key={transaction.id} />
          )}
        </tbody>
      </table>
    </>
  )
}

export default AccountDetail;