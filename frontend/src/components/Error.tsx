import React from "react";
import { ApolloError } from "apollo-client";

const Error = (error: ApolloError) => {
  if (!error) return <></>;
  let errorMessage;
  if (error.networkError) {
    errorMessage = (
      <>
        <h3>Internal Server Error</h3>
        <code>
          Something is wrong.
        </code>
      </>
    );
  }
  if (error.graphQLErrors && error.graphQLErrors.length > 0) {
    errorMessage = (
      <>
        <ul>
          {error.graphQLErrors.map(({ message, details }, i) => (
            <li key={i}>
              <span className="message">{message}</span>
              {details && (
                <ul>
                  {Object.keys(details).map(key => (
                    <li key={key}>
                      {key} {details[key]}
                    </li>
                  ))}
                </ul>
              )}
            </li>
          ))}
        </ul>
      </>
    );
  }
  return <div className="errors">{errorMessage}</div>;
};

export default Error;
