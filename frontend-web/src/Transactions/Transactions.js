import { DataGrid } from "@material-ui/data-grid";
import { useState, useEffect, useCallback } from "react";
import { AppBar, Toolbar, Button, Typography, Snackbar, Box, Select, MenuItem, TextField } from '@material-ui/core';

export default function Transactions({ userToken, SERVER_URL, back }) {
  let [lbpInput, setLbpInput] = useState("");
  let [usdInput, setUsdInput] = useState("");
  let [transactionType, setTransactionType] = useState("usd-to-lbp");
  let [userTransactions, setUserTransactions] = useState([]);

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
      .then(() => { if (userToken !== null) fetchUserTransactions(); })

    setLbpInput("")
    setUsdInput("")
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
    <div className="wrapper">
      <Typography variant="h5" style={{ fontWeight: 600 }}>Record a recent transaction</Typography>
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

      <div>
        <Button variant="contained" color="primary" onClick={back}> Back </Button>
      </div>
    </div >
  );
}