import React from 'react';
import Header from "./components/Header"
import { BrowserRouter, Route, Switch } from "react-router-dom";
import "./assets/app.scss"
import SignUp from "./pages/SignUp"
import SignIn from "./pages/SignIn"
import Accounts from "./pages/Accounts"

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <div className="App">
        <Header />
        <div id="content">
          <Switch>
            <Route path="/sign-up" component={SignUp} />
            <Route path="/sign-in" component={SignIn} />
            <Route path="/accounts/:public_id" component={Accounts} />
            <Route path="/accounts" component={Accounts} />
          </Switch>
        </div>
      </div>
    </BrowserRouter>
  );
}

export default App;
