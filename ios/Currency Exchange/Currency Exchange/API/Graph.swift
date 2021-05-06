//
//  Graph.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 5/5/21.
//

import Foundation
import Charts

class Graph {
    // reverse distance from current date:
    // e.g. for a graph that spans 90 days,
    // if date is 90 days away, then it is at x=0
    func createChartDataEntries(from rates: [GraphRate]) -> [ChartDataEntry] {
        var result = [ChartDataEntry]()
        let count = rates.count
        
        for i in 0..<count {
            if (rates[i].rate == -1) {
                continue
            }
            result.append(ChartDataEntry(x: Double(i), y: Double(rates[i].rate)))
        }
        
        return result
    }
}
