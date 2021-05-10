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
        
//        lineChartView.animate(xAxisDuration: 1)

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
    
    func setDataSets(entries: [[ChartDataEntry]], labels: [String]) {
        let colors = ChartColorTemplates.vordiplom()[0..<entries.count]
        
        let dataSets = (0..<entries.count).map { i -> LineChartDataSet in
            let set = LineChartDataSet(entries: entries[i], label: labels[i])
            set.drawCirclesEnabled = false
            set.mode = .cubicBezier
            set.lineWidth = 3.0
            set.setColor(colors[i])
            set.fillColor = colors[i]
            set.fillAlpha = 0.7
            set.drawFilledEnabled = true
            set.drawHorizontalHighlightIndicatorEnabled = false
            
            return set
        }
        
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        
        lineChartView.data = data
    }
    
    func setDataSets(_ count: Int, range: UInt32) {
        let colors = ChartColorTemplates.vordiplom()[0...2]
        
        let block: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let dataSets = (0..<3).map { i -> LineChartDataSet in
            let yVals = (0..<count).map(block)
            let set = LineChartDataSet(entries: yVals, label: "DataSet \(i)")
            set.lineWidth = 2.5
            set.circleRadius = 4
            set.circleHoleRadius = 2
            let color = colors[i % colors.count]
            set.setColor(color)
            set.setCircleColor(color)
            
            return set
        }
        
        dataSets[0].lineDashLengths = [5, 5]
        dataSets[0].colors = ChartColorTemplates.vordiplom()
        dataSets[0].circleColors = ChartColorTemplates.vordiplom()
        
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        lineChartView.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
