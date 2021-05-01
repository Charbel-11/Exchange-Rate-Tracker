//
//  CalculatorViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/30/21.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    let buyUsd: Float
    let sellUsd: Float
    
    let calculatorAmountTextField = BoldBorderlessTextField(placeholder: "Amount")
    var calculatorSegmentedControl: UISegmentedControl! = nil
    let calculateButton = FilledButton(textColor: .white, backgroundColor: .systemBlue)
    
    init(buyUsd: Float, sellUsd: Float) {
        self.buyUsd = buyUsd
        self.sellUsd = sellUsd
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        setupNavBar()
        setupSubviews()
        setupLayout()
        setupTargets()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Calculator"
    }
    
    private func setupSubviews() {
        let segmentItems = ["USD", "LBP"]
        calculatorSegmentedControl = UISegmentedControl(items: segmentItems)
        calculatorSegmentedControl.selectedSegmentIndex = 0
        calculatorSegmentedControl.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        calculatorAmountTextField.textAlignment = .natural
        calculatorAmountTextField.setupForPriceContent()
        
        calculateButton.setTitle("Calculate", for: .normal)
    }
    
    private func setupLayout() {
        let hStack = UIStackView(arrangedSubviews: [calculatorSegmentedControl, calculatorAmountTextField])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8
        
        calculatorSegmentedControl.heightAnchor.constraint(equalTo: calculatorAmountTextField.heightAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            hStack,
            calculateButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTargets() {
        calculatorSegmentedControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        calculateButton.addTarget(self, action: #selector(calculateTapped(_:)), for: .touchUpInside)
    }

    @objc private func segmentControl(_ segmentedControl: UISegmentedControl) {
        print("value: \(segmentedControl.selectedSegmentIndex)")
    }
    
    @objc private func calculateTapped(_ sender: UIButton) {
        if let amountText = calculatorAmountTextField.text, let amount = Float(amountText) {
            
            let usdToLbp = calculatorSegmentedControl.selectedSegmentIndex == 0
            if usdToLbp && sellUsd == -1 || !usdToLbp && buyUsd == -1 {
                let alert = UIAlertController(title: "Exchange Calculator",
                                              message: "Exchange rate not available for given conversion type.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            var convertedAmount: Float = 0
            var startCurrency = ""
            var endCurrency = ""
            
            if usdToLbp {
                convertedAmount = amount * sellUsd
                startCurrency = "USD"
                endCurrency = "LBP"
            } else {
                convertedAmount = amount * buyUsd
                startCurrency = "LBP"
                endCurrency = "USD"
            }
            
            let message = "\(startCurrency)\(amountText) converted to \(endCurrency) is \(endCurrency)" + String(format: "%.2f", convertedAmount) + "."
            
            let alert = UIAlertController(title: "Exchange Calculator",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        calculatorAmountTextField.resignFirstResponder()
    }
}
