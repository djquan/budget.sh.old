import React from "react";
import AccountSidebar from "../components/AccountSidebar";
import AccountDetail from "../components/AccountDetail"
import { useParams } from "react-router";

export interface Account {
  name: string,
  id: string,
  userAccount: boolean
}

const Accounts = () => {
  const { id } = useParams();

  return (
    <div className="d-flex" id="wrapper">
      <AccountSidebar />
      <div id="page-content-wrapper">
        <div className="container-fluid">
          {!id && (
            <>
              <h1 className="mt-4">All Accounts</h1>
            </>
          )}
          {id && (
            <AccountDetail id={id} key={id} />
          )}
        </div>
      </div>
    </div>
  );
}

export default Accounts