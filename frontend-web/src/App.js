import './App.css';
import { AppBar, Toolbar, Button, Typography, Snackbar, Box, Select, MenuItem, TextField } from '@material-ui/core';
import { useState, useEffect, useCallback } from "react";
import { Alert } from "@material-ui/lab";
import UserCredentialsDialog from "./UserCredentialsDialog/UserCredentialsDialog";
import { getUserToken, saveUserToken } from "./localStorage";
import { DataGrid } from "@material-ui/data-grid";

var SERVER_URL = "http://127.0.0.1:5000";

function App() {
  const States = {
    PENDING: "PENDING",
    USER_CREATION: "USER_CREATION",
    USER_LOG_IN: "USER_LOG_IN",
    USER_AUTHENTICATED: "USER_AUTHENTICATED",
  }

  let [buyUsdRate, setBuyUsdRate] = useState(null);
  let [sellUsdRate, setSellUsdRate] = useState(null);
  let [lbpInput, setLbpInput] = useState("");
  let [usdInput, setUsdInput] = useState("");
  let [transactionType, setTransactionType] = useState("usd-to-lbp");
  let [conversionInput, setConversionInput] = useState(0);
  let [conversionOutput, setConversionOutput] = useState(0);
  let [conversionType, setConversionType] = useState("usd-to-lbp");
  let [userToken, setUserToken] = useState(getUserToken());
  let [authState, setAuthState] = useState(States.PENDING);
  let [userTransactions, setUserTransactions] = useState([]);

  function fetchRates() {
    fetch(`${SERVER_URL}/exchangeRate`)
      .then(response => response.json())
      .then(data => {
        setSellUsdRate(data.usd_to_lbp);
        setBuyUsdRate(data.lbp_to_usd);
      });
  }
  useEffect(fetchRates, []);

  function addItem() {
    var ratio = lbpInput / usdInput;
    if (isNaN(ratio) || ratio == Infinity || ratio == 0) { return; }

    var h = { 'Content-Type': 'application/json' };
    if (userToken !== null) {
      h = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userToken
      };
    }

    fetch(`${SERVER_URL}/transaction`, {
      method: 'POST',
      headers: h,
      body: JSON.stringify({
        "lbp_amount": lbpInput,
        "usd_amount": usdInput,
        "usd_to_lbp": transactionType == "usd-to-lbp"
      })
    })
      .then(fetchRates);

    setLbpInput("")
    setUsdInput("")
  }

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
        setAuthState(States.USER_AUTHENTICATED);
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

  function convert() {
    if (conversionType === "usd-to-lbp") {
      setConversionOutput(conversionInput * sellUsdRate);
    }
    else {
      setConversionOutput(conversionInput * buyUsdRate);
    }
  }

  const fetchUserTransactions = useCallback(() => {
    fetch(`${SERVER_URL}/transaction`, {
      headers: {
        Authorization: `Bearer ${userToken}`,
      },
    })
      .then((response) => response.json())
      .then((transactions) => setUserTransactions(transactions));
  }, [userToken]);
  useEffect(() => {
    if (userToken) {
      fetchUserTransactions();
    }
  }, [fetchUserTransactions, userToken]);

  return (
    <div>
      <UserCredentialsDialog
        open={authState === States.USER_CREATION}
        onSubmit={createUser}
        onClose={() => setAuthState(States.PENDING)}
        title="Register"
        submitText="Submit" />
      <UserCredentialsDialog
        open={authState === States.USER_LOG_IN}
        onSubmit={login}
        onClose={() => setAuthState(States.PENDING)}
        title="Log In"
        submitText="Submit" />

      <Snackbar
        elevation={6}
        variant="filled"
        open={authState === States.USER_AUTHENTICATED}
        autoHideDuration={2000}
        onClose={() => setAuthState(States.PENDING)}
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
                    onClick={() => setAuthState(States.USER_CREATION)}
                  >
                    Register
                  </Button>
                  <Button
                    color="inherit"
                    onClick={() => setAuthState(States.USER_LOG_IN)}
                  >
                    Login
                  </Button>
                </div>
              )}
          </div>
        </Toolbar>
      </AppBar>

      <div className="wrapper">
        <Box mb={2} ><Typography variant="h5" style={{ fontWeight: 600 }}>Today's Exchange Rate</Typography></Box>
        <p>LBP to USD Exchange Rate</p>
        <h3>Buy USD: <span id="buy-usd-rate">{
          buyUsdRate == null ? "Not available yet" : buyUsdRate.toFixed(2)
        }</span></h3>
        <h3>Sell USD: <span id="sell-usd-rate">{
          sellUsdRate == null ? "Not available yet" : sellUsdRate.toFixed(2)
        }</span></h3>

        <hr />

        <Box mb={2} ><Typography variant="h5" style={{ fontWeight: 600 }}>Rate Calculator</Typography></Box>
        <form name="conversion-entry">
          <div>
            <TextField id="lbp-amount" label={conversionType === "lbp-to-usd" ? "LBP Amount" : "USD Amount"}
              value={conversionInput} onChange={e => setConversionInput(e.target.value)} />
          </div>
        </form>

        <div>
          <TextField id="lbp-amount" label={conversionType !== "lbp-to-usd" ? "LBP Amount" : "USD Amount"}
            InputProps={{ readOnly: true, }} value={conversionOutput.toFixed(2)} />
        </div>

        <Box my={2}>
          <Select id="conversion-type" value={conversionType} onChange={e => { setConversionType(e.target.value); setConversionOutput(0); setConversionInput(0); }}>
            <MenuItem value="usd-to-lbp">USD to LBP</MenuItem>
            <MenuItem value="lbp-to-usd">LBP to USD</MenuItem>
          </Select>
        </Box>
        
        <Box mt={1}><Button id="convert-button" variant="contained" color="primary" onClick={convert}>Convert</Button></Box>
      </div>

      <div className="wrapper">
        <Box mb={2} ><Typography variant="h5" style={{ fontWeight: 600 }}>Record a recent transaction</Typography></Box>
        <form name="transaction-entry">
          <div>
            <TextField id="lbp-amount" label="LBP Amount" value={lbpInput} onChange={e => setLbpInput(e.target.value)} />
          </div>
          <div>
            <TextField id="usd-amount" label="USD Amount" value={usdInput} onChange={e => setUsdInput(e.target.value)} />
          </div>

          <Box my={2}>
            <Select id="transaction-type" value={transactionType} onChange={e => { setTransactionType(e.target.value); }}>
              <MenuItem value="usd-to-lbp">USD to LBP</MenuItem>
              <MenuItem value="lbp-to-usd">LBP to USD</MenuItem>
            </Select>
          </Box>

          <Box mt={1}><Button id="add-button" variant="contained" color="primary" onClick={addItem}>Add</Button></Box>
        </form>
      </div>

      {userToken && (
        <div className="wrapper">
          <Box mb={2}><Typography variant="h5" style={{ fontWeight: 600 }}>Your Transactions</Typography></Box>
          <DataGrid
            rows={userTransactions}
            columns={[
              { field: "added_date", headerName: "Added Date", width: 200 },
              { field: "lbp_amount", headerName: "LBP Amount", width: 175 },
              { field: "usd_amount", headerName: "USD Amount", width: 175 },
              { field: "usd_to_lbp", headerName: "USD To LBP", width: 175 },
            ]}
            autoHeight
          />
        </div>
      )}
    </div>
  );
}

export default App;
