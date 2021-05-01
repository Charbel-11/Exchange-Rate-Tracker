import { useState, useEffect } from "react";
import { Typography } from '@material-ui/core';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Paper from '@material-ui/core/Paper';
import { Chart } from 'react-charts'


export default function Statistics({ SERVER_URL }) {
    let [rows, setRows] = useState([]);
    let [graphData, setGraphData] = useState([]);

    function createData(name, max, median, stdev, mode, variance) {
        return { name, max, median, stdev, mode, variance };
    }

    function fetchStats() {
        fetch(`${SERVER_URL}/stats/30`)
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
        fetch(`${SERVER_URL}/graph/usd_to_lbp/10`)
            .then(response => response.json())
            .then(data => {
                console.log(data)
            });
    }
    useEffect(fetchGraph1, []);





    const data = [
        {
            label: 'USD to LBP',
            data: [[2, 1]]
        },
        {
            label: 'LBP to USD',
            data: [[0, 3], [1, 1], [2, 5], [3, 6], [4, 4]]
        }
    ]





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

            <div
                style={{
                    width: '400px',
                    height: '300px'
                }}
            >
                <Chart data={data}
                    axes={
                        [
                            { primary: true, type: 'time', position: 'bottom' },
                            { type: 'linear', position: 'left' }
                        ]
                    }
                    tooltip
                />
            </div>

        </div>
    );
}