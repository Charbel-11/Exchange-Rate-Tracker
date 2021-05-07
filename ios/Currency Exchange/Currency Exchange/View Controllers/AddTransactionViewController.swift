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
    
    let userListButton: ListButton = ListButton(title: "Send to User")
    var selectedUserIndex: Int? = nil
    
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
        
        userListButton.isHidden = authentication.getToken() == nil
        
        addButton.setTitle("Add Transaction", for: .normal)
        debugButton.setTitle("DEBUG: Add 10 Random Transactions", for: .normal)
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            usdTextField,
            lbpTextField,
            segmentedControl,
            userListButton,
            addButton,
            debugButton
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
        userListButton.addTarget(self, action: #selector(userListTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        debugButton.addTarget(self, action: #selector(debugTapped), for: .touchUpInside)
    }
    
    @objc private func userListTapped() {
        voyage.get(with: URL(string: "\(K.url)/users")!,
                   completion: didFetchUsers(users:),
                   fail: failFetchUsers(error:),
                   bearerToken: authentication.getToken())
    }
    
    private func didFetchUsers(users: [User]) {
        // new array with only usernames of fetched users
        let userNames: [String] = users.map { user in
            return user.userName
        }
        
        let userListVC = OptionListViewController(options: userNames,
                                                  selectedRow: selectedUserIndex,
                                                  callBack: selectedUser(username:newSelectedIndex:))
        userListVC.view.backgroundColor = .systemGroupedBackground
        userListVC.navigationItem.title = "Send to User"
        
        show(userListVC, sender: self)
    }
    
    private func selectedUser(username: String?, newSelectedIndex: Int?) {
        selectedUserIndex = newSelectedIndex
        userListButton.chosenOptionLabel.text = username == nil ? "None" : username
    }
    
    private func failFetchUsers(error: Error) {
        print("Failed to fetch users: \(error)")
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
            
            let url = addTransactionURL()
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
        print("Failed to add transaction: \(error)")
    }
    
    @objc private func debugTapped(_ sender: UIButton) {
        let url = addTransactionURL()
        
        for _ in 0..<10 {
            let usdToLbp = Bool.random()
            let usdAmount = 1
            let lbpAmount = Int.random(in: 8000...20000)
            
            let transaction = NewTransaction(usdAmount: Float(usdAmount),
                                             lbpAmount: Float(lbpAmount),
                                             usdToLbp: usdToLbp)
            
            voyage.post(with: url,
                        body: transaction,
                        completion: nothing(transaction:),
                        fail: didFailAddTransaction(error:),
                        bearerToken: authentication.getToken())
        }
        successAction()
        let alert = UIAlertController(title: "Debug Action",
                                      message: "10 (almost) random transactions added!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func nothing(transaction: Transaction) {
        
    }
    
    private func addTransactionURL() -> URL {
        var urlString: String = ""
        if selectedUserIndex == nil {
            urlString =  "\(K.url)/transaction"
        } else {
            urlString =  "\(K.url)/userTransaction/\(userListButton.chosenOptionLabel.text!)"
        }
        
        return URL(string: urlString)!
    }
}
