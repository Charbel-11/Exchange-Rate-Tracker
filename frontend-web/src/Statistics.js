import { useState, useEffect, useCallback } from "react";
import { Typography, Box } from '@material-ui/core';

export default function ExchangeRates({SERVER_URL}){
    let [buyUsdRate, setBuyUsdRate] = useState(null);
    let [sellUsdRate, setSellUsdRate] = useState(null);

    function fetchRates() {
        fetch(`${SERVER_URL}/exchangeRate/30`)
          .then(response => response.json())
          .then(data => {
            setSellUsdRate(data.usd_to_lbp);
            setBuyUsdRate(data.lbp_to_usd);
          });
      }
      useEffect(fetchRates, []);

      return (
          <div>
              <Box mb={2} ><Typography variant="h5" style={{ fontWeight: 600 }}>Today's Exchange Rate</Typography></Box>
            <p>LBP to USD Exchange Rate</p>
            <h3>Buy USD: <span id="buy-usd-rate">{
                buyUsdRate == null ? "Not available yet" : buyUsdRate.toFixed(2)
            }</span></h3>
            <h3>Sell USD: <span id="sell-usd-rate">{
                sellUsdRate == null ? "Not available yet" : sellUsdRate.toFixed(2)
            }</span></h3>
          </div>
      );
}

export function Statistics(){

}