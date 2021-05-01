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
    
    let authentication = Authentication()
    let voyage = Voyage()
    
    let successAction: () -> Void
    
    init(successAction: @escaping() -> Void) {
        self.successAction = successAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupLayout()
        setupTargets()
    }
}


// MARK: Subviews + Layout
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
        
        view.addSubview(cancelButton)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: Targets + Actions
extension AddTransactionViewController {
    private func setupTargets() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addTapped() {
        if let usdText = usdTextField.text, let usdAmount = Float(usdText),
           let lbpText = lbpTextField.text, let lbpAmount = Float(lbpText) {
            
            let usdToLbp = segmentedControl.selectedSegmentIndex == 1
            
            let transaction = NewTransaction(usdAmount: usdAmount,
                                          lbpAmount: lbpAmount,
                                          usdToLbp: usdToLbp)
            
            let url = URL(string: "\(K.url)/transaction")!
            voyage.post(with: url,
                        body: transaction,
                        completion: didAddTransaction(transaction:),
                        fail: didFailAddTransaction(error:),
                        bearerToken: authentication.getToken())
        }
    }
    
    private func didAddTransaction(transaction: Transaction) {
        print("Added transaction successfully!")
        successAction()
        dismiss(animated: true, completion: nil)
    }
    
    private func didFailAddTransaction(error: Error) {
        
    }
}
