//
//  StatisticsView.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 5/1/21.
//

import UIKit

class StatisticsView: UIView {
    
    var daysSegmentedControl: UISegmentedControl! = nil

    var sellUsdLabels = [UILabel]()
    var buyUsdLabels = [UILabel]()
    
    var segmentedControl: UISegmentedControl! = nil
    
    let authentication = Authentication()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension StatisticsView {
    private func setupSubviews() {
        daysSegmentedControl = UISegmentedControl(items: ["90 days", "60 days", "30 days"])
        daysSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        daysSegmentedControl.selectedSegmentIndex = 2
        
        let types = ["Max", "Med", "Stdev"]
        
        for i in 0..<4 {
            let label = UILabel()
            
            if i == 0 {
                label.font = .boldSystemFont(ofSize: 20)
                label.text = "Sell USD"
            } else {
                label.font = .systemFont(ofSize: 20)
                label.text = "\(types[i-1]): 0.00"
            }
            
            sellUsdLabels.append(label)
        }
        
        for i in 0..<4 {
            let label = UILabel()
            
            if i == 0 {
                label.font = .boldSystemFont(ofSize: 20)
                label.text = "Buy USD"
            } else {
                label.font = .systemFont(ofSize: 20)
                label.text = "\(types[i-1]): 0.00"
            }
            
            buyUsdLabels.append(label)
        }
        
        segmentedControl = UISegmentedControl(items: ["All Transactions", "Between Users"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.isHidden = authentication.getToken() == nil
    }
}


extension StatisticsView {
    private func setupLayout() {
        
        let sellVStack = UIStackView()
        sellVStack.axis = .vertical
        sellVStack.spacing = 8
        
        for label in sellUsdLabels {
            sellVStack.addArrangedSubview(label)
        }
        
        let buyVStack = UIStackView()
        buyVStack.axis = .vertical
        buyVStack.spacing = 8
        
        for label in buyUsdLabels {
            buyVStack.addArrangedSubview(label)
        }
        
        let separator = UIView()
        separator.backgroundColor = .quaternaryLabel
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        let hStack = UIStackView(arrangedSubviews: [sellVStack, separator, buyVStack])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 16
        
        self.addSubview(daysSegmentedControl)
        self.addSubview(hStack)
        self.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            daysSegmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            daysSegmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            daysSegmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            hStack.topAnchor.constraint(equalTo: daysSegmentedControl.bottomAnchor, constant: 20),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
//            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
            
            segmentedControl.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
}
