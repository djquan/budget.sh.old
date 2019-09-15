import React from "react";
import { ApolloError } from "apollo-client";

const Error = (error: ApolloError) => {
  if (!error) return <></>;

  const hasGraphQLErrors = error.graphQLErrors && error.graphQLErrors.length;
  let errorMessage;

  if (hasGraphQLErrors) {
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
