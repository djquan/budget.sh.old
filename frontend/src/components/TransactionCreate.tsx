import React, { Component, ChangeEvent } from "react";
import DatePicker from "react-datepicker";

import "react-datepicker/dist/react-datepicker.css";
import Button from 'react-bootstrap/Button';


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

  handleDateChange = (date: Date) => {
    this.setState({
      transactionDate: date
    });
  };

  handleChange = (event: ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;
    this.setState({
      [name]: value
    })
  }

  handleButtonClick = () => {
    console.log(this.state)
  }

  render(): React.ReactNode {
    return (
      <>
        <tr key="transaction-create">
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
            <Button
              variant="primary"
              onClick={this.handleButtonClick}
            >Create</Button>
          </td>
        </tr>
      </>
    )
  }
}

export default TransactionCreate;