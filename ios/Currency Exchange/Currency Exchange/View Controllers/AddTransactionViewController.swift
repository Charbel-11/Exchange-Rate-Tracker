//
//  AddTransactionViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/6/21.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    let usdTextField = BoldBorderlessTextField(placeholder: "USD Amount")
    let lbpTextField = BoldBorderlessTextField(placeholder: "LBP Amount")
    var segmentedControl: UISegmentedControl! = nil
    let addButton = FilledButton(textColor: .white, backgroundColor: .systemOrange)
    let debugButton = FilledButton(textColor: .white, backgroundColor: .systemPurple)
    
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
        
        setupNavBar()
        setupSubviews()
        setupLayout()
        setupTargets()
    }
}


// MARK: Navigation Bar
extension AddTransactionViewController {
    private func setupNavBar() {
        navigationItem.title = "New Transaction"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = cancelButton
    }
}


// MARK: Subviews + Layout
extension AddTransactionViewController {
    private func setupSubviews() {
        
        usdTextField.setupForPriceContent()
        lbpTextField.setupForPriceContent()
        
        let segmentItems = ["Buy USD", "Sell USD"]
        segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.selectedSegmentIndex = 0
        
        addButton.setTitle("Add Transaction", for: .normal)
        debugButton.setTitle("Add 10 Random Transaction", for: .normal)
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
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: Targets + Actions
extension AddTransactionViewController {
    private func setupTargets() {
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        debugButton.addTarget(self, action: #selector(debugTapped), for: .touchUpInside)
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
        successAction()
        dismiss(animated: true, completion: nil)
    }
    
    private func didFailAddTransaction(error: Error) {
        
    }
    
    @objc private func debugTapped(_ sender: UIButton) {
        
    }
}
