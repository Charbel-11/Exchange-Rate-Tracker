//
//  TransactionsViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/29/21.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    var transactions = [Transaction]()
    let tableView = UITableView()
    
    let authentication = Authentication()
    let voyage = Voyage()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupTableView()
        fetchTransactions()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Past Transactions"
        
        let graphButton = UIBarButtonItem(title: "Graph", style: .plain, target: self, action: #selector(graphTapped))
        navigationItem.rightBarButtonItem = graphButton
    }
    
    @objc private func graphTapped() {
        
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

}


// MARK: Data Source
extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as! TransactionCell
        let transaction = transactions[indexPath.row]
        
        if transaction.usdToLbp {
            cell.exchangeTypeLabel.text = "SELL USD"
            cell.wrapper.backgroundColor = .systemOrange
        } else {
            cell.exchangeTypeLabel.text = "BUY USD"
            cell.wrapper.backgroundColor = .systemGreen
        }
        
        let usdAmountText = String(format: "%.2f", transaction.usdAmount)
        let lbpAmountText = String(format: "%.2f", transaction.lbpAmount)
        
        let arrowImageAttachment = NSTextAttachment()
        let arrowImage = UIImage(systemName: "arrow.left.arrow.right")?.withTintColor(.label)
        arrowImageAttachment.image = arrowImage

        let fullString = NSMutableAttributedString(string: "USD\(usdAmountText) ")
        fullString.append(NSAttributedString(attachment: arrowImageAttachment))
        fullString.append(NSAttributedString(string: " LBP\(lbpAmountText)"))
        cell.rateLabel.attributedText = fullString
        
        cell.dateLabel.text = transaction.addedDate
        
        return cell
    }
}


// MARK: Networking
extension TransactionsViewController {
    private func fetchTransactions() {
        voyage.get(with: URL(string: "\(K.url)/transaction")!,
                   completion: didFetchTransactions(transactions:),
                   fail: failFetchTransactions(error:),
                   bearerToken: authentication.getToken())
    }
    
    private func didFetchTransactions(transactions: [Transaction]) {
        self.transactions = transactions
        tableView.reloadData()
    }
    
    private func failFetchTransactions(error: Error) {
        print("Failed to fetch past transactions: \(error)")
    }
}
