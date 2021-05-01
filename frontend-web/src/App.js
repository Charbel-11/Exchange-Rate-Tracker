import './App.css';
import { AppBar, Toolbar, Button, Typography, Snackbar, Box, Select, MenuItem, TextField } from '@material-ui/core';
import { useState, useEffect, useCallback } from "react";
import { Alert } from "@material-ui/lab";
import UserCredentialsDialog from "./UserCredentialsDialog/UserCredentialsDialog";
import { getUserToken, saveUserToken } from "./localStorage";
import Transactions from "./Transactions/Transactions"
import Conversion from "./Conversion"
import ExchangeRates from "./Statistics"

var SERVER_URL = "http://127.0.0.1:5000";

function App() {
  const AuthStates = {
    PENDING: "PENDING",
    USER_CREATION: "USER_CREATION",
    USER_LOG_IN: "USER_LOG_IN",
    USER_AUTHENTICATED: "USER_AUTHENTICATED",
  }
  const PageStates = {
    MAIN: "MAIN",
    TRANSACTIONS: "TRANSACTIONS",
    CONVERSION: "CONVERSION",
  }

  let [userToken, setUserToken] = useState(getUserToken());
  let [authState, setAuthState] = useState(AuthStates.PENDING);
  let [pageState, setPageState] = useState(PageStates.MAIN);

  function login(username, password) {
    return fetch(`${SERVER_URL}/authentication`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        user_name: username,
        password: password,
      }),
    })
      .then((response) => response.json())
      .then((body) => {
        setAuthState(AuthStates.USER_AUTHENTICATED);
        setUserToken(body.token);
        saveUserToken(body.token);
      });
  }

  function createUser(username, password) {
    return fetch(`${SERVER_URL}/user`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        user_name: username,
        password: password,
      }),
    }).then((response) => login(username, password));
  }

  function logout() {
    saveUserToken(null);
    setUserToken(null);
  }

  return (
    <div>
      <UserCredentialsDialog
        open={authState === AuthStates.USER_CREATION}
        onSubmit={createUser}
        onClose={() => setAuthState(AuthStates.PENDING)}
        title="Register"
        submitText="Submit" />
      <UserCredentialsDialog
        open={authState === AuthStates.USER_LOG_IN}
        onSubmit={login}
        onClose={() => setAuthState(AuthStates.PENDING)}
        title="Log In"
        submitText="Submit" />

      <Snackbar
        elevation={6}
        variant="filled"
        open={authState === AuthStates.USER_AUTHENTICATED}
        autoHideDuration={2000}
        onClose={() => setAuthState(AuthStates.PENDING)}
      >
        <Alert severity="success">Success</Alert>
      </Snackbar>

      <AppBar position="static">
        <Toolbar classes={{ root: "nav" }}>
          <Typography variant="h5">LBP Exchange Tracker</Typography>
          <div>
            {userToken !== null ? (
              <Button color="inherit" onClick={logout}>
                Logout
              </Button>
            ) : (
                <div>
                  <Button
                    color="inherit"
                    onClick={() => setAuthState(AuthStates.USER_CREATION)}
                  >
                    Register
                  </Button>
                  <Button
                    color="inherit"
                    onClick={() => setAuthState(AuthStates.USER_LOG_IN)}
                  >
                    Login
                  </Button>
                </div>
              )}
          </div>
        </Toolbar>
      </AppBar>

      <div className="wrapper">
        <ExchangeRates SERVER_URL={SERVER_URL} />
        <hr />
        <Conversion SERVER_URL={SERVER_URL}/>
      </div>

      <Transactions userToken={userToken} SERVER_URL={SERVER_URL}/>
    </div>
  );
}

export default App;
