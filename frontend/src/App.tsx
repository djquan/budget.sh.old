import React from 'react';
import Header from "./components/Header"
import { BrowserRouter, Route, Switch } from "react-router-dom";
import "./assets/app.scss"
import SignUp from "./pages/SignUp"
import SignIn from "./pages/SignIn"

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <div className="App">
        <Header />
        <div id="content">
          <Switch>
            <Route path="/sign-up" component={SignUp} />
            <Route path="/sign-in" component={SignIn} />
          </Switch>
        </div>
      </div>
    </BrowserRouter>
  );
}

export default App;
