import React, { ChangeEvent, useState } from "react";
import DatePicker from "react-datepicker";

import "react-datepicker/dist/react-datepicker.css";
import Button from 'react-bootstrap/Button';

const TransactionCreate = ({ accountId }: { accountId: string }) => {
  const [state, setState] = useState({
    transactionDate: new Date(),
    accountName: "",
    creditAmount: "",
    debitAmount: "",
    accountId: accountId,
  })

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

  const handleButtonClick = () => {
    console.log(state)
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
          <input name="accountName" type="text" value={state.accountName} onChange={handleChange} />
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