import { useState, useEffect } from "react";
import { Typography, Tab, Tabs } from '@material-ui/core';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Paper from '@material-ui/core/Paper';
import { LineChart, Line, CartesianGrid, XAxis, YAxis, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export default function Statistics({ SERVER_URL }) {
    let [rows, setRows] = useState([]);
    let [graphUsdToLbpData, setGraphUsdToLbpData] = useState([]);
    let [graphLbpToUsdData, setGraphLbptoUsdData] = useState([]);
    let [graphData, setGraphData] = useState([])
    let [graphDayCnt, setGraphDayCnt] = useState(30);

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

    function fetchGraphs() {
        fetchGraph1(graphDayCnt);
        fetchGraph2(graphDayCnt);
    }
    useEffect(fetchGraphs, [graphDayCnt]);

    function fetchGraph1(nDays) {
        return fetch(`${SERVER_URL}/graph/usd_to_lbp/` + nDays)
            .then(response => response.json())
            .then(data => {
                var usdToLbpArr = []
                for (var i = 0; i < data.length; i++) {
                    usdToLbpArr.push({ name: data[i].date, usdToLbp: Math.max(0, data[i].rate.toFixed(2)) });
                }
                setGraphUsdToLbpData(usdToLbpArr);
            });
    }

    function fetchGraph2(nDays) {
        return fetch(`${SERVER_URL}/graph/lbp_to_usd/` + nDays)
            .then(response => response.json())
            .then(data => {
                var lbpToUsdArr = []
                for (var i = 0; i < data.length; i++) {
                    lbpToUsdArr.push({ name: data[i].date, lbpToUsd: Math.max(0, data[i].rate.toFixed(2)) });
                }
                setGraphLbptoUsdData(lbpToUsdArr);
            });
    }

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

            <Paper>
                <Tabs
                    style={{ marginBottom: 15 }}
                    value={graphDayCnt}
                    onChange={(event, nDays) => setGraphDayCnt(nDays)}
                    indicatorColor="primary"
                    textColor="primary"
                    centered
                >
                    <Tab label="30 days" value={30} />
                    <Tab label="60 days" value={60} />
                    <Tab label="90 days" value={90} />
                </Tabs>

                <ResponsiveContainer width="100%" height={350}>
                    <LineChart data={graphData} margin={{ top: 5, right: 20, bottom: 20, left: 0 }}>
                        <Line type="monotone" dataKey="usdToLbp" name="USD to LBP" stroke="#82ca9d" />
                        <Line type="monotone" dataKey="lbpToUsd" name="LBP to USD" stroke="#8884d8" />
                        <CartesianGrid stroke="#ccc" strokeDasharray="5 5" />
                        <XAxis dataKey="name" />
                        <YAxis />
                        <Legend />
                        <Tooltip />
                    </LineChart>
                </ResponsiveContainer>
            </Paper>

        </div>
    );
}