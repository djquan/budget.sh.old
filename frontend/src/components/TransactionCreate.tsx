import React, { Component, ChangeEvent } from "react";
import DatePicker from "react-datepicker";
import gql from "graphql-tag";
import "react-datepicker/dist/react-datepicker.css";
import Button from 'react-bootstrap/Button';
import { Mutation } from "react-apollo";
import Loading from "./Loading";
import Error from "./Error";
import { GET_ACCOUNT_QUERY } from "./AccountDetail";

const CREATE_TRANSACTION_FOR_ACCOUNT_MUTATION = gql`
  mutation CreateTransactions($credit: TransactionInput, $debit: TransactionInput) {
    createTransactions(credit: $credit, debit: $debit) {
      credit {
        id
      }
      debit {
        id
      }
    }
  }
`;

interface Props {
  accountId: string
}

class TransactionCreate extends Component<Props> {
  state = {
    transactionDate: new Date(),
    accountName: "",
    creditAmount: "",
    debitAmount: "",
    accountId: this.props.accountId,
  }

  credit = {
    transactionDate: "2019-09-19",
    amount: "",
    account_id: this.props.accountId,
    currency_code: "USD",
    tags: [],
  }

  debit = {
    transactionDate: "2019-09-19",
    amount: "",
    account_id: "31da8480-4b3c-432d-a296-d0c48b88badf",
    currency_code: "USD",
    tags: [],
  }

  handleDateChange = (date: Date) => {
    this.setState({
      transactionDate: date
    });
    const formatted = new Date(date.getTime() - (date.getTimezoneOffset() * 60000))
      .toISOString()
      .split("T")[0];

    this.credit.transactionDate = formatted
    this.debit.transactionDate = formatted
  };

  handleChange = (event: ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;

    if (name === "creditAmount" || name === "debitAmount") {
      this.credit.amount = value
      this.debit.amount = value
    }

    this.setState({
      [name]: value
    })
  }

  render(): React.ReactNode {
    return (
      <Mutation
        mutation={CREATE_TRANSACTION_FOR_ACCOUNT_MUTATION}
        refetchQueries={[
          {
            query: GET_ACCOUNT_QUERY,
            variables: {
              id: this.props.accountId
            }

          }
        ]}
        variables={
          {
            credit: this.credit,
            debit: this.debit
          }
        }>
        {(create: any, { _loading, error }: any) => {
          return (
            < tr key="transaction-create" >
              <Error error={error} />
              <th scope="row">
                <DatePicker
                  selected={this.state.transactionDate}
                  onChange={this.handleDateChange}
                />
              </th>
              <td>
                <input name="accountName" type="text" value={this.state.accountName} onChange={this.handleChange} />
              </td>
              <td>
                <input name="creditAmount" type="text" value={this.state.creditAmount} onChange={this.handleChange} disabled={this.state.debitAmount !== ""} />
              </td>
              <td>
                <input name="debitAmount" type="text" value={this.state.debitAmount} onChange={this.handleChange} disabled={this.state.creditAmount !== ""} />
              </td>
              <td>
                <Button variant="primary" onClick={create} >
                  Create
              </Button>
              </td>
            </tr>
          )
        }
        }
      </ Mutation >
    );
  }
}

export default TransactionCreate;