import React, { ChangeEvent, useState } from "react";
import DatePicker from "react-datepicker";

import "react-datepicker/dist/react-datepicker.css";
import Button from 'react-bootstrap/Button';
import { useQuery, useMutation } from "react-apollo";
import { LIST_ACCOUNTS_QUERY } from "./AccountSidebar";
import gql from "graphql-tag";
import { GET_ACCOUNT_QUERY } from "./AccountDetail";
import { Account } from "../pages/Accounts";
import { ACCOUNT_CREATE_MUTATION, AllTasksResult } from "./AccountCreateForm";

const CREATE_TRANSACTION_WITH_ACCOUNT_ID_QUERY = gql`
  mutation CreateTransactions($credit: TransactionInput, $debit: TransactionInput) {
     createTransactions(credit: $credit, debit: $debit) {
       credit {
         account {
           id
         }
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
       debit {
         account {
           id
         }
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
`

interface GetAccountResult {
  getAccount: Account
}

const TransactionCreate = ({ accountId }: { accountId: string }) => {
  const { data } = useQuery(LIST_ACCOUNTS_QUERY);

  const [createAccount] = useMutation(
    ACCOUNT_CREATE_MUTATION,
    {
      update(cache, { data: { createAccount } }) {
        const { listAccounts } = cache.readQuery<AllTasksResult>({ query: LIST_ACCOUNTS_QUERY })!;
        cache.writeQuery({
          query: LIST_ACCOUNTS_QUERY,
          data: { listAccounts: listAccounts.concat([createAccount]) },
        });
        data.listAccounts.unshift(createAccount)
      }
    }
  )

  const emptyState = () => ({
    transactionDate: new Date(),
    accountName: "",
    creditAmount: "",
    debitAmount: "",
    accountId: accountId,
  })

  const [state, setState] = useState(emptyState())

  const [createTransactions] = useMutation(
    CREATE_TRANSACTION_WITH_ACCOUNT_ID_QUERY,
    {
      update(cache, { data: { createTransactions } }) {
        [createTransactions.credit, createTransactions.debit].forEach(transaction => {
          try {
            let cacheResult = cache.readQuery<GetAccountResult | null>({ query: GET_ACCOUNT_QUERY, variables: { id: transaction.account.id } });

            if (cacheResult) {
              let account = cacheResult.getAccount;
              account.transactions = [transaction].concat(account.transactions);
              cache.writeQuery({
                query: GET_ACCOUNT_QUERY,
                variables: { id: accountId },
                data: { getAccount: account }
              })
            }
          }
          catch { }
          setState(emptyState())
        })
      }
    }
  )

  const handleDateChange = (date: Date) => {
    setState({
      ...state,
      ...{
        transactionDate: date
      }
    });
  };

  const handleChange = (event: ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;

    setState({
      ...state,
      ...{ [name]: value }
    })
  }

  const saveAccount = (event: ChangeEvent<HTMLInputElement>) => {
    const account = data.listAccounts.find((account: Account) => {
      return account && account.name && account.name.toLowerCase() === state.accountName.toLowerCase()
    });

    if (!account) {
      createAccount({
        variables: {
          name: event.target.value,
          userAccount: false,
        }
      })
    }
  }

  const handleButtonClick = () => {
    const account = data.listAccounts.find((account: Account) => {
      return account && account.name && account.name.toLowerCase() === state.accountName.toLowerCase()
    });

    const date = new Date(state.transactionDate.getTime() - (state.transactionDate.getTimezoneOffset() * 60000))
      .toISOString()
      .split("T")[0];


    const isCredit = state.creditAmount !== "";
    const amount = parseFloat(isCredit ? state.creditAmount : state.debitAmount) * 100
    const shared = {
      currencyCode: "USD",
      transactionDate: date,
      amount: String(amount),
      tags: [],
    }

    const creditAccountId = isCredit ? accountId : account.id;
    const debitAccountId = isCredit ? account.id : accountId;

    createTransactions({
      variables: {
        credit: {
          ...shared,
          ...{ accountId: creditAccountId }
        },
        debit: {
          ...shared,
          ...{ accountId: debitAccountId }
        }
      }
    })
  }

  return (
    <>
      <tr key="transaction-create">
        <th scope="row">
          <DatePicker
            selected={state.transactionDate}
            onChange={handleDateChange}
          />
        </th>
        <td>
          <input name="accountName" type="text" value={state.accountName} onChange={handleChange} onBlur={saveAccount} />
        </td>
        <td>
          <input name="creditAmount" type="text" value={state.creditAmount} onChange={handleChange} disabled={state.debitAmount !== ""} />
        </td>
        <td>
          <input name="debitAmount" type="text" value={state.debitAmount} onChange={handleChange} disabled={state.creditAmount !== ""} />
        </td>
        <td>
          <Button
            variant="primary"
            onClick={handleButtonClick}
          >Create</Button>
        </td>
      </tr>
    </>
  )
}

export default TransactionCreate;