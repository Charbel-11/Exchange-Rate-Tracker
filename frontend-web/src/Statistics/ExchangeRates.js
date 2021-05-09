import { useState, useEffect } from "react";
import { TextField, Typography } from '@material-ui/core';
import Input from '@material-ui/core/Input';

export default function ExchangeRates({ SERVER_URL, setRates }) {
  let [buyUsdRate, setBuyUsdRate] = useState(-1);
  let [sellUsdRate, setSellUsdRate] = useState(-1);
  let [daysConsidered, setDaysConsidered] = useState(3);

  function fetchRates() {
    return fetch(`${SERVER_URL}/exchangeRate/` + daysConsidered)
      .then(response => response.json())
      .then(data => {
        setRates(data);
        setSellUsdRate(data.usd_to_lbp);
        setBuyUsdRate(data.lbp_to_usd);
      });
  }
  useEffect(fetchRates, [daysConsidered]);

  return (
    <div>
      <Typography variant="h5" style={{ fontWeight: 600 }}>Today's Exchange Rate</Typography>
      <div className="subTitle">
        <p>LBP to USD Exchange Rate</p>
      </div>
      <h3>Buy USD Rate: <span id="buy-usd-rate">{
        buyUsdRate == -1 ? "Not available yet" : buyUsdRate.toFixed(2)
      }</span></h3>
      <h3>Sell USD Rate: <span id="sell-usd-rate">{
        sellUsdRate == -1 ? "Not available yet" : sellUsdRate.toFixed(2)
      }</span></h3>

      <Typography variant="inherit">Days Considered:
      <Input
          style={{ width: "8%", marginLeft: 10 }}
          value={daysConsidered}
          onChange={({ target: { value } }) => setDaysConsidered(value)}
          type="number" />
      </Typography>
    </div>
  );
}