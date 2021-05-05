//
//  GraphView.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 5/1/21.
//

import UIKit
import Charts

class GraphView: UIView {

    public let lineChartView = LineChartView()
    public var segmentedControl: UISegmentedControl! = nil
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        
        let segmentItems = ["90 days", "60 days", "30 days"]
        segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 2
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
//        lineChartView.backgroundColor = .systemBlue
        
        lineChartView.rightAxis.enabled = false
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .label
        yAxis.axisLineColor = .label
        yAxis.labelPosition = .outsideChart
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        
        lineChartView.xAxis.setLabelCount(6, force: false)
        lineChartView.xAxis.labelTextColor = .label
        lineChartView.xAxis.axisLineColor = .label
        
        lineChartView.animate(xAxisDuration: 2.5)

        self.addSubview(lineChartView)
        self.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            lineChartView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
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
        setData(values)
    }
    
    public func setData(_ values: [ChartDataEntry]) {
        let set1 = LineChartDataSet(entries: values, label: "Y-AXIS LABEL")
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 3.0
        set1.setColor(.systemBlue)
        set1.fillColor = .systemBlue
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        
        lineChartView.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
