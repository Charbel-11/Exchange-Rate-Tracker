//
//  GraphViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/30/21.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    let lineChartView = LineChartView()
    
    let values: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 0),
        ChartDataEntry(x: 1, y: 1),
        ChartDataEntry(x: 2, y: 0.5),
        ChartDataEntry(x: 3, y: 4),
        ChartDataEntry(x: 4, y: 2),
        ChartDataEntry(x: 5, y: 3),
        ChartDataEntry(x: 6, y: 2),
        ChartDataEntry(x: 7, y: 5),
        ChartDataEntry(x: 8, y: 4),
        ChartDataEntry(x: 9, y: 7)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.backgroundColor = .systemBlue
        lineChartView.delegate = self
        
        lineChartView.rightAxis.enabled = false
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        
        lineChartView.xAxis.setLabelCount(6, force: false)
        lineChartView.xAxis.labelTextColor = .white
        lineChartView.xAxis.axisLineColor = .white
        
        lineChartView.animate(xAxisDuration: 2.5)

        view.addSubview(lineChartView)
        NSLayoutConstraint.activate([
            lineChartView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            lineChartView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            lineChartView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            lineChartView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
        
        setData()
    }
    
    private func setData() {
        
    }

}

extension GraphViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
