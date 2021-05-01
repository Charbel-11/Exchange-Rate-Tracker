import { useState, useEffect } from "react";
import { Typography } from '@material-ui/core';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Paper from '@material-ui/core/Paper';
import { LineChart, Line, CartesianGrid, XAxis, YAxis, Tooltip, Legend } from 'recharts';

export default function Statistics({ SERVER_URL }) {
    let [rows, setRows] = useState([]);
    let [graphUsdToLbpData, setGraphUsdToLbpData] = useState([]);
    let [graphLbpToUsdData, setGraphLbptoUsdData] = useState([]);
    let [graphData, setGraphData] = useState([])

    function createData(name, max, median, stdev, mode, variance) {
        return { name, max, median, stdev, mode, variance };
    }

    function fetchStats() {
        return fetch(`${SERVER_URL}/stats/30`)
            .then(response => response.json())
            .then(data => {
                setRows(
                    [
                        createData("USD to LBP", data.max_usd_to_lbp.toFixed(2),
                            data.median_usd_to_lbp.toFixed(2), data.stdev_usd_to_lbp.toFixed(2),
                            data.mode_usd_to_lbp.toFixed(2), data.variance_usd_to_lbp.toFixed(2)),
                        createData("LBP to USD", data.max_lbp_to_usd.toFixed(2),
                            data.median_lbp_to_usd.toFixed(2), data.stdev_lbp_to_usd.toFixed(2),
                            data.mode_lbp_to_usd.toFixed(2), data.variance_lbp_to_usd.toFixed(2))
                    ]
                )
            });
    }
    useEffect(fetchStats, []);

    function fetchGraph1() {
        return fetch(`${SERVER_URL}/graph/usd_to_lbp/20`)
            .then(response => response.json())
            .then(data => {
                var usdToLbpArr = []
                for (var i = 0; i < data.length; i++) {
                    usdToLbpArr.push({ name: data[i].date, usdToLbp: Math.max(0, data[i].rate.toFixed(2)) });
                }
                setGraphUsdToLbpData(usdToLbpArr);
            });
    }
    useEffect(fetchGraph1, []);

    function fetchGraph2() {
        return fetch(`${SERVER_URL}/graph/lbp_to_usd/20`)
            .then(response => response.json())
            .then(data => {
                var lbpToUsdArr = []
                for (var i = 0; i < data.length; i++) {
                    lbpToUsdArr.push({ name: data[i].date, lbpToUsd: Math.max(0, data[i].rate.toFixed(2)) });
                }
                setGraphLbptoUsdData(lbpToUsdArr);
            });
    }
    useEffect(fetchGraph2, []);

    function setGraph() {
        if (graphLbpToUsdData.length == 0 || graphLbpToUsdData.length != graphUsdToLbpData.length) {
            return;
        }

        var curData = []
        for (var i = 0; i < graphLbpToUsdData.length; i++) {
            curData.push({
                name: graphLbpToUsdData[i].name,
                lbpToUsd: graphLbpToUsdData[i].lbpToUsd,
                usdToLbp: graphUsdToLbpData[i].usdToLbp
            })
        }
        setGraphData(curData)
    }
    useEffect(setGraph, [graphLbpToUsdData, graphUsdToLbpData]);

    return (
        <div>
            <Typography variant="h5" style={{ fontWeight: 600 }}>Statistics</Typography>

            <br />
            <TableContainer component={Paper}>
                <Table aria-label="simple table">
                    <TableHead>
                        <TableRow>
                            <TableCell>Exchange Type</TableCell>
                            <TableCell align="right">Max</TableCell>
                            <TableCell align="right">Median</TableCell>
                            <TableCell align="right">Stdev</TableCell>
                            <TableCell align="right">Mode</TableCell>
                            <TableCell align="right">Variance</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map((row) => (
                            <TableRow key={row.name}>
                                <TableCell component="th" scope="row">
                                    {row.name}
                                </TableCell>
                                <TableCell align="right">{row.max}</TableCell>
                                <TableCell align="right">{row.median}</TableCell>
                                <TableCell align="right">{row.stdev}</TableCell>
                                <TableCell align="right">{row.mode}</TableCell>
                                <TableCell align="right">{row.variance}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </TableContainer>
            <br /> <br />

            <Typography variant="h5" style={{ fontWeight: 600, marginBottom: 15 }}>Rates over Time</Typography>

            <LineChart width={900} height={300} data={graphData} margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
                <Line type="monotone" dataKey="usdToLbp" name="USD to LBP" stroke="#82ca9d" />
                <Line type="monotone" dataKey="lbpToUsd" name="LBP to USD" stroke="#8884d8" />
                <CartesianGrid stroke="#ccc" strokeDasharray="5 5" />
                <XAxis dataKey="name" />
                <YAxis />
                <Legend />
                <Tooltip />
            </LineChart>
        </div>
    );
}