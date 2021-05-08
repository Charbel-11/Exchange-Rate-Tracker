import { DataGrid } from "@material-ui/data-grid";
import { useState, useEffect, useCallback } from "react";
import { Button, Typography, Box, Select, MenuItem, TextField, Tab, Tabs } from '@material-ui/core';
import Paper from '@material-ui/core/Paper';
import Autocomplete from '@material-ui/lab/Autocomplete';

export default function Transactions({ userToken, SERVER_URL }) {
  let [lbpInput, setLbpInput] = useState("");
  let [usdInput, setUsdInput] = useState("");
  let [transactionType, setTransactionType] = useState("usd-to-lbp");
  let [otherUser, setOtherUser] = useState("");
  let [errorMsg, setErrorMsg] = useState("");
  let [allUsers, setAllUsers] = useState([]);
  let [userTransactions, setUserTransactions] = useState([]);
  let [tableType, setTableType] = useState(0);

  const columnsTable1 = [
    { field: "added_date", headerName: "Added Date", width: 200 },
    { field: "lbp_amount", headerName: "LBP Amount", width: 175 },
    { field: "usd_amount", headerName: "USD Amount", width: 175 },
    { field: "type", headerName: "Type", width: 175 }
  ];
  const columnsTable2 = [
    { field: "added_date", headerName: "Added Date", width: 200 },
    { field: "lbp_amount", headerName: "LBP Amount", width: 175 },
    { field: "usd_amount", headerName: "USD Amount", width: 175 },
    { field: "user_name", headerName: "Other User", width: 175 },
    { field: "type", headerName: "Type", width: 175 }
  ];

  function fetchAllUsers() {
    return fetch(`${SERVER_URL}/users`, {
      headers: {
        Authorization: `Bearer ${userToken}`,
      },
    })
      .then(response => response.json())
      .then(data => setAllUsers(data))
  }
  useEffect(fetchAllUsers, []);

  function addItem() {
    var ratio = lbpInput / usdInput;
    if (isNaN(ratio) || ratio == Infinity || ratio == 0) {
      setErrorMsg("Invalid Transaction");
      return;
    }
    setErrorMsg("");

    var h = { 'Content-Type': 'application/json' };
    if (userToken !== null) {
      h = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + userToken
      };
    }

    var path = `${SERVER_URL}/transaction`;
    if (otherUser != "") { path = `${SERVER_URL}/userTransaction/` + otherUser; }

    return fetch(path, {
      method: 'POST',
      headers: h,
      body: JSON.stringify({
        "lbp_amount": lbpInput,
        "usd_amount": usdInput,
        "usd_to_lbp": transactionType == "usd-to-lbp"
      })
    })
      .then(() => {
        setLbpInput("")
        setUsdInput("")
        if (userToken !== null) fetchUserTransactions();
      })
  }

  const fetchUserTransactions = useCallback(() => {
    console.log(tableType);
    var route = tableType == 0 ? "transaction" : "userTransactions";
    fetch(`${SERVER_URL}/` + route, {
      headers: {
        Authorization: `Bearer ${userToken}`,
      },
    })
      .then((response) => response.json())
      .then((transactions) => {
        for (var i = 0; i < transactions.length; i++) {
          transactions[i]["added_date"] = new Date(transactions[i]["added_date"]).toLocaleString();
          transactions[i]["type"] = transactions[i]["usd_to_lbp"] ? "USD to LBP" : "LBP to USD";
          transactions[i]["id"] = i;
        }
        console.log(transactions);
        setUserTransactions(transactions);
      }
      );
  }, [userToken, tableType]);
  useEffect(() => {
    if (userToken) {
      fetchUserTransactions();
    }
  }, [fetchUserTransactions, userToken, tableType]);

  return (
    <div className="wrapper">
      <Typography variant="h5" style={{ fontWeight: 600 }}>Record a new transaction</Typography>
      <form name="transaction-entry">
        <div>
          <TextField id="lbp-amount" label="LBP Amount *" value={lbpInput} onChange={e => setLbpInput(e.target.value)} />
        </div>
        <div>
          <TextField id="usd-amount" label="USD Amount *" value={usdInput} onChange={e => setUsdInput(e.target.value)} />
        </div>

        {userToken && (
          <div>
            <Autocomplete
              options={allUsers}
              getOptionLabel={(user) => user.user_name}
              style={{ width: 200 }}
              onChange={(event, user) => setOtherUser(user ? user.user_name : "")}
              renderInput={(params) => <TextField {...params} label="Send to User" />}
            />
          </div>
        )}

        <Box my={2}>
          <Select id="transaction-type" value={transactionType} onChange={e => { setTransactionType(e.target.value); }}>
            <MenuItem value="usd-to-lbp">USD to LBP</MenuItem>
            <MenuItem value="lbp-to-usd">LBP to USD</MenuItem>
          </Select>
        </Box>

        <div className="">
          <Typography color="error">{errorMsg}</Typography>
        </div>
        <Box mt={1}><Button id="add-button" variant="contained" color="primary" onClick={addItem}>Add</Button></Box>
      </form>

      {userToken && (
        <div>
          <Typography variant="h5" style={{ fontWeight: 600, marginTop: 40, marginBottom: 20 }}>Your Transactions</Typography>
          <Paper>
            <Tabs
              value={tableType}
              onChange={(event, nType) => setTableType(nType)}
              indicatorColor="primary"
              textColor="primary"
              centered
            >
              <Tab label="All Transactions" value={0} />
              <Tab label="Between Users" value={1} />
            </Tabs>
          </Paper>

          <DataGrid
            pageSize={10}
            rows={userTransactions}
            columns={tableType == 0 ? columnsTable1 : columnsTable2}
            autoHeight
          />
        </div>
      )}
    </div >
  );
}