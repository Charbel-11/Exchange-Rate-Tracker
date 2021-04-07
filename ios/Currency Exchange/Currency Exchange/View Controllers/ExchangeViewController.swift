//
//  ViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/6/21.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    let buyUsdLabel = UILabel()
    let buyUsdAmountLabel = UILabel()
    
    let sellUsdLabel = UILabel()
    let sellUsdAmountLabel = UILabel()
    
    let pastTransactionsButton = FilledButton(textColor: .white, backgroundColor: .systemBlue)
    
    let calculatorTitleLabel = UILabel()
    let calculatorAmountTextField = BoldBorderlessTextField(placeholder: "Amount")
    var calculatorSegmentedControl: UISegmentedControl! = nil
    let calculateButton = FilledButton(textColor: .white, backgroundColor: .systemBlue)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupSubviews()
        setupLayout()
        
        
    }
}

// MARK: Navigation Bar
extension ExchangeViewController {
    private func setupNavBar() {
        navigationItem.title = "Currency Exchange"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Right bar button items
        let addTransactionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransactionTapped))
        navigationItem.rightBarButtonItem = addTransactionButton
        
        let loginButton = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(loginTapped))
        let registerButton = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerTapped))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        
        navigationItem.leftBarButtonItems = [registerButton, loginButton]
    }
    
    @objc private func addTransactionTapped() {
        print("Tapped Add")
    }
    
    @objc private func loginTapped() {
        print("Tapped Login")
    }
    
    @objc private func registerTapped() {
        print("Tapped Register")
    }
    
    @objc private func logoutTapped() {
        print("Tapped Logout")
    }
}

// MARK: Subviews Config
extension ExchangeViewController {
    private func setupSubviews() {
        buyUsdLabel.text = "Buy USD"
        buyUsdLabel.font = .preferredFont(forTextStyle: .title2)
        buyUsdAmountLabel.font = .preferredFont(forTextStyle: .subheadline)
        buyUsdAmountLabel.text = "N/A"
        
        sellUsdLabel.text = "Sell USD"
        sellUsdLabel.font = .preferredFont(forTextStyle: .title2)
        sellUsdAmountLabel.font = .preferredFont(forTextStyle: .subheadline)
        sellUsdAmountLabel.text = "N/A"
        
        pastTransactionsButton.setTitle("Past Transactions", for: .normal)
        
        calculatorTitleLabel.text = "Calculator"
        calculatorTitleLabel.textAlignment = .center
        calculatorTitleLabel.font = .preferredFont(forTextStyle: .title1)
        
        let segmentItems = ["USD", "LBP"]
        calculatorSegmentedControl = UISegmentedControl(items: segmentItems)
        calculatorSegmentedControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        calculatorSegmentedControl.selectedSegmentIndex = 1
        
        calculateButton.setTitle("Calculate", for: .normal)
    }
}


// MARK: Layout
extension ExchangeViewController {
    private func setupLayout() {
        let buyVStack = createVStack([buyUsdLabel, buyUsdAmountLabel])
//        buyVStack.backgroundColor = .red
        let sellVStack = createVStack([sellUsdLabel, sellUsdAmountLabel])
//        sellVStack.backgroundColor = .red
        
        let rateHStack = UIStackView(arrangedSubviews: [buyVStack, sellVStack])
        rateHStack.translatesAutoresizingMaskIntoConstraints = false
        rateHStack.axis = .horizontal
        rateHStack.distribution = .fillEqually
        rateHStack.alignment = .top
        rateHStack.spacing = 60
        
        let contentVStack = UIStackView(arrangedSubviews: [
            rateHStack,
            calculatorTitleLabel,
            calculatorAmountTextField,
            calculatorSegmentedControl,
            calculateButton
        ])
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        contentVStack.axis = .vertical
        contentVStack.spacing = 20
        contentVStack.setCustomSpacing(60, after: rateHStack)
        
        view.addSubview(contentVStack)
        NSLayoutConstraint.activate([
            contentVStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentVStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            contentVStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
    
    private func createVStack(_ views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        return stackView
    }
}

// MARK: Actions
extension ExchangeViewController {
    @objc private func segmentControl(_ segmentedControl: UISegmentedControl) {
        
    }
}
