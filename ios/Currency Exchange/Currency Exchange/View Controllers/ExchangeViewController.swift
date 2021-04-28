//
//  ViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/6/21.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    var loginButton: UIBarButtonItem! = nil
    var registerButton: UIBarButtonItem! = nil
    var logoutButton: UIBarButtonItem! = nil
    
    let buyUsdLabel = UILabel()
    let buyUsdAmountLabel = UILabel()
    
    let sellUsdLabel = UILabel()
    let sellUsdAmountLabel = UILabel()
    
    let pastTransactionsButton = FilledButton(textColor: .white, backgroundColor: .systemBlue)
    
    let calculatorTitleLabel = UILabel()
    let calculatorAmountTextField = BoldBorderlessTextField(placeholder: "Amount")
    var calculatorSegmentedControl: UISegmentedControl! = nil
    let calculateButton = FilledButton(textColor: .white, backgroundColor: .systemBlue)
    
    let authentication = Authentication()
    let voyage = Voyage()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupSubviews()
        setupLayout()
        setupTargets()
        fetchRates()
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
        
        loginButton = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(loginTapped))
        registerButton = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerTapped))
        logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        
        if authentication.getToken() != nil {
            navigationItem.leftBarButtonItem = logoutButton
        } else {
            navigationItem.leftBarButtonItems = [registerButton, loginButton]
        }
    }
    
    @objc private func addTransactionTapped() {
        let addTransactionVC = AddTransactionViewController(successAction: addTransactionSuccessful)
        present(addTransactionVC, animated: true, completion: nil)
    }
    
    private func addTransactionSuccessful() {
        fetchRates()
    }
    
    @objc private func loginTapped() {
        let authVC = AuthenticationViewController(submitAction: loginAction(userCredentials:), submitTitle: "Login")
        present(authVC, animated: true, completion: nil)
    }
    
    @objc private func registerTapped() {
        let authVC = AuthenticationViewController(submitAction: registerAction(userCredentials:), submitTitle: "Register")
        present(authVC, animated: true, completion: nil)
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
        buyUsdAmountLabel.text = "Potato"
        
        sellUsdLabel.text = "Sell USD"
        sellUsdLabel.font = .preferredFont(forTextStyle: .title2)
        sellUsdAmountLabel.font = .preferredFont(forTextStyle: .subheadline)
        sellUsdAmountLabel.text = "Potato"
        
        pastTransactionsButton.setTitle("Past Transactions", for: .normal)
        
        calculatorTitleLabel.text = "Calculator"
        calculatorTitleLabel.textAlignment = .center
        calculatorTitleLabel.font = .preferredFont(forTextStyle: .title1)
        
        let segmentItems = ["USD", "LBP"]
        calculatorSegmentedControl = UISegmentedControl(items: segmentItems)
        calculatorSegmentedControl.selectedSegmentIndex = 0
        
        calculateButton.setTitle("Calculate", for: .normal)
    }
}


// MARK: Layout
extension ExchangeViewController {
    private func setupLayout() {
        let buyVStack = createVStack([buyUsdLabel, buyUsdAmountLabel])
        let sellVStack = createVStack([sellUsdLabel, sellUsdAmountLabel])
        
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
            contentVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
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
    private func setupTargets() {
        calculatorSegmentedControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
    }
    
    @objc private func segmentControl(_ segmentedControl: UISegmentedControl) {
        print("value: \(segmentedControl.selectedSegmentIndex)")
    }
    
    private func loginAction(userCredentials: UserCredentials) {
        voyage.post(with: URL(string: "\(K.url)/authentication")!, body: userCredentials)
        { [weak self] (tokenModel: Token) in
            self?.authentication.saveToken(token: tokenModel.token)
            self?.navigationItem.setLeftBarButton(self?.logoutButton, animated: true)
        } fail: { error in
            print("Failed to login user: \(error)")
        }
    }
    
    private func registerAction(userCredentials: UserCredentials) {
        voyage.post(with: URL(string: "\(K.url)/user")!, body: userCredentials)
        { [weak self] (user: User) in
            self?.loginAction(userCredentials: userCredentials)
        } fail: { error in
            print("Failed to register user: \(error)")
        }
    }
    
    private func didAuthenticate(token: Token) {
        
    }
}


// MARK: Networking Calls
extension ExchangeViewController {
    private func fetchRates() {
        let url = URL(string: "\(K.url)/exchangeRate/3")!
        voyage.get(with: url, completion: didFetchRates(exchangeRates:), fail: didFailToFetchRates(error:), bearerToken: authentication.getToken())
    }
    
    private func didFetchRates(exchangeRates: ExchangeRates) {
        print("Fetched Rates!")
        let buyUsd = exchangeRates.lbpToUsd
        let sellUsd = exchangeRates.usdToLbp
        
        DispatchQueue.main.async {
            self.buyUsdAmountLabel.text = buyUsd == -1 ? "N/A" : String(format: "$%.2f", buyUsd)
            self.sellUsdAmountLabel.text = sellUsd == -1 ? "N/A" : String(format: "LBP%.2f", sellUsd)
        }
    }
    
    private func didFailToFetchRates(error: Error) {
        print("Failed to fetch rates: \(error)")
    }
}
