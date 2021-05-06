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
    
    let calculatorButton = FilledButton(textColor: .white, backgroundColor: .systemBlue)
    let statisticsButton = FilledButton(textColor: .white, backgroundColor: .systemBlue)
    
    let graphView = GraphView()
    
    let authentication = Authentication()
    let graph = Graph()
    let voyage = Voyage()
    
    var buyUsd: Float = -1
    var sellUsd: Float = -1
    
    var usdToLbpGraphRates = [GraphRate]()
    var lbpToUsdGraphRates = [GraphRate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupSubviews()
        setupLayout()
        setupTargets()
        updateAuthenticationUI()
        fetchRates()
        fetchGraph()
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
        
        calculatorButton.setTitle("Exchange Calculator", for: .normal)
        
        statisticsButton.setTitle("Statistics", for: .normal)
        statisticsButton.layer.opacity = 0
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
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
        
        let separator = UIView()
        separator.backgroundColor = .quaternaryLabel
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let contentVStack = UIStackView(arrangedSubviews: [
            rateHStack,
            separator,
            calculatorButton,
            statisticsButton
        ])
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        contentVStack.axis = .vertical
        contentVStack.spacing = 20
        
        view.addSubview(contentVStack)
        view.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            contentVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentVStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentVStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            graphView.topAnchor.constraint(equalTo: contentVStack.bottomAnchor, constant: 40),
            graphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            graphView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            graphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
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


// MARK: Authentication Actions
extension ExchangeViewController {
    private func updateAuthenticationUI() {
        let token = authentication.getToken()
        
        navigationItem.setLeftBarButtonItems(token == nil ? [registerButton, loginButton] : [logoutButton],
                                             animated: true)
        UIView.animate(withDuration: 0.2) {
            self.statisticsButton.layer.opacity = token == nil ? 0 : 1.0
        }
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
        authentication.clearToken()
        updateAuthenticationUI()
    }
    
    private func loginAction(userCredentials: UserCredentials) {
        voyage.post(with: URL(string: "\(K.url)/authentication")!, body: userCredentials)
        { (tokenModel: Token) in
            self.authentication.saveToken(token: tokenModel.token)
            self.updateAuthenticationUI()
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
}


// MARK: Actions
extension ExchangeViewController {
    private func setupTargets() {
        calculatorButton.addTarget(self, action: #selector(calculatorTapped(_:)), for: .touchUpInside)
        statisticsButton.addTarget(self, action: #selector(pastTransactionsTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func addTransactionTapped() {
        let addTransactionVC = AddTransactionViewController(successAction: {
            self.fetchRates()
        })
        present(UINavigationController(rootViewController: addTransactionVC), animated: true, completion: nil)
    }
    
    @objc private func calculatorTapped(_ sender: UIButton) {
        let calcVC = CalculatorViewController(buyUsd: buyUsd, sellUsd: sellUsd)
        show(calcVC, sender: self)
    }
    
    @objc private func pastTransactionsTapped(_ sender: UIButton) {
        let transactionsVC = TransactionsViewController()
        show(transactionsVC, sender: self)
    }
}


// MARK: Fetching Exchange Rates
extension ExchangeViewController {
    private func fetchRates() {
        let url = URL(string: "\(K.url)/exchangeRate/3")!
        voyage.get(with: url, completion: didFetchRates(exchangeRates:), fail: didFailToFetchRates(error:), bearerToken: authentication.getToken())
    }
    
    private func didFetchRates(exchangeRates: ExchangeRates) {
        buyUsd = exchangeRates.lbpToUsd
        sellUsd = exchangeRates.usdToLbp
        
        DispatchQueue.main.async {
            self.buyUsdAmountLabel.text = self.buyUsd == -1 ? "N/A" : String(format: "LBP%.2f", self.buyUsd)
            self.sellUsdAmountLabel.text = self.sellUsd == -1 ? "N/A" : String(format: "LBP%.2f", self.sellUsd)
        }
    }
    
    private func didFailToFetchRates(error: Error) {
        print("Failed to fetch rates: \(error)")
    }
}


// MARK: Fetching Graph
extension ExchangeViewController {
    private func fetchGraph() {
        let days: Int = 90 / (graphView.segmentedControl.selectedSegmentIndex+1)
        print("DAYS: \(days)")
        
        voyage.get(with: URL(string: "\(K.url)/graph/usd_to_lbp/\(days)")!,
                   completion: didFetchUsdToLbpGraph(graphRates:),
                   fail: didFailFetchGraph(error:),
                   bearerToken: authentication.getToken())
    }
    
    private func didFetchUsdToLbpGraph(graphRates: [GraphRate]) {
        usdToLbpGraphRates = graphRates
        
        let days: Int = 90 / (graphView.segmentedControl.selectedSegmentIndex+1)
        
        voyage.get(with: URL(string: "\(K.url)/graph/lbp_to_usd/\(days)")!,
                   completion: didFetchLbpToUsdGraph(graphRates:),
                   fail: didFailFetchGraph(error:),
                   bearerToken: authentication.getToken())
    }
    
    private func didFetchLbpToUsdGraph(graphRates: [GraphRate]) {
        lbpToUsdGraphRates = graphRates
        
        let usdToLbpEntries = graph.createChartDataEntries(from: usdToLbpGraphRates)
        let lbpToUsdEntries = graph.createChartDataEntries(from: lbpToUsdGraphRates)
        
        graphView.setDataSets(entries: [usdToLbpEntries, lbpToUsdEntries], labels: ["Sell USD", "Buy USD"])
    }
    
    private func didFailFetchGraph(error: Error) {
        print(error)
    }
}
