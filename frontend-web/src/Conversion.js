import { useState, useEffect, useCallback } from "react";
import { AppBar, Toolbar, Button, Typography, Snackbar, Box, Select, MenuItem, TextField } from '@material-ui/core';
import ExchangeRates from "./Statistics"

export default function Conversion({SERVER_URL}){
    let [conversionInput, setConversionInput] = useState(0);
    let [conversionOutput, setConversionOutput] = useState(0);
    let [conversionType, setConversionType] = useState("usd-to-lbp");
   
  function convert() {
    if (conversionType === "usd-to-lbp") {
      setConversionOutput(conversionInput * ExchangeRates.sellUsdRate);
    }
    else {
      setConversionOutput(conversionInput * ExchangeRates.buyUsdRate);
    }
  }

  return (
      <div>
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
  );
}