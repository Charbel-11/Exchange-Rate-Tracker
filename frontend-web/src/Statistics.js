import { useState, useEffect } from "react";
import { Typography } from '@material-ui/core';

export default function ExchangeRates({ SERVER_URL, setRates }) {
  let [buyUsdRate, setBuyUsdRate] = useState(-1);
  let [sellUsdRate, setSellUsdRate] = useState(-1);

  function fetchRates() {
    fetch(`${SERVER_URL}/exchangeRate/30`)
      .then(response => response.json())
      .then(data => {
        setRates(data);
        setSellUsdRate(data.usd_to_lbp);
        setBuyUsdRate(data.lbp_to_usd);
      });
  }
  useEffect(fetchRates, []);

  return (
    <div>
      <Typography variant="h5" style={{ fontWeight: 600 }}>Today's Exchange Rate</Typography>
      <p>LBP to USD Exchange Rate</p>
      <h3>Buy 1 USD with <span id="buy-usd-rate">{
        buyUsdRate == -1 ? "??" : buyUsdRate.toFixed(2)
      }</span> LBP</h3>
      <h3>Sell 1 USD for <span id="sell-usd-rate">{
        sellUsdRate == -1 ? "??" : sellUsdRate.toFixed(2)
      }</span> LBP</h3>
    </div>
  );
}

export function Statistics() {

}