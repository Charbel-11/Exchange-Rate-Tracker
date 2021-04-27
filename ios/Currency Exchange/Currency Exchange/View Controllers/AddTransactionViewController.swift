//
//  AddTransactionViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/6/21.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    let cancelButton = UIButton()
    let usdTextField = BoldBorderlessTextField(placeholder: "USD Amount")
    let lbpTextField = BoldBorderlessTextField(placeholder: "LBP Amount")
    var segmentedControl: UISegmentedControl! = nil
    let addButton = FilledButton(textColor: .white, backgroundColor: .systemOrange)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupLayout()
        setupTargets()
    }
}


extension AddTransactionViewController {
    private func setupSubviews() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill")!.withConfiguration(UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        cancelButton.tintColor = .secondaryLabel
        
        usdTextField.setupForPriceContent()
        lbpTextField.setupForPriceContent()
        
        let segmentItems = ["Buy USD", "Sell USD"]
        segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.selectedSegmentIndex = 0
        
        addButton.setTitle("Add Transaction", for: .normal)
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            usdTextField,
            lbpTextField,
            segmentedControl,
            addButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.setCustomSpacing(40, after: segmentedControl)
        
        view.addSubview(cancelButton)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
}


extension AddTransactionViewController {
    private func setupTargets() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addTapped() {
        if let usdAmount = usdTextField.text, let lbpAmount = lbpTextField.text {
            let usdToLbp = segmentedControl.selectedSegmentIndex == 1
            
            // POST transaction
        }
    }
}
