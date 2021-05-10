//
//  DetailedStatisticsViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/29/21.
//

import UIKit

// MARK: Views + Layout
class DetailedStatisticsViewController: UIViewController {
    
    var transactions = [Transaction]()
    var userTransactions = [UserTransaction]()
    
    let tableView = UITableView()
    let statisticsView = StatisticsView()
    
    let authentication = Authentication()
    let voyage = Voyage()
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupTableView()
        setupTargets()
        fetchTableData()
        fetchStatistics()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Past Transactions"
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        statisticsView.backgroundColor = .secondarySystemBackground
        statisticsView.translatesAutoresizingMaskIntoConstraints = false
        statisticsView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        // greater height for segmented control in case user is logged in
        let height: CGFloat = authentication.getToken() == nil ? 150 : 250
        statisticsView.heightAnchor.constraint(equalToConstant: height).isActive = true
        tableView.tableHeaderView = statisticsView
        
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func fetchTableData() {
        if statisticsView.segmentedControl.selectedSegmentIndex == 0 {
            fetchTransactions()
        } else {
            fetchUserTransactions()
        }
    }
}


// MARK: Data Source
extension DetailedStatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statisticsView.segmentedControl.selectedSegmentIndex == 0 {
            return transactions.count
        } else {
            return userTransactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as! TransactionCell
        if statisticsView.segmentedControl.selectedSegmentIndex == 0 {
            
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
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: transaction.addedDate)!
            
            dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
            cell.dateLabel.text = dateFormatter.string(from: date)
            
            cell.secondUserLabel.text = ""
            
            return cell
            
        } else {
            
            let userTransaction = userTransactions[indexPath.row]
            
            if userTransaction.usdToLbp {
                cell.exchangeTypeLabel.text = "SELL USD"
                cell.wrapper.backgroundColor = .systemOrange
            } else {
                cell.exchangeTypeLabel.text = "BUY USD"
                cell.wrapper.backgroundColor = .systemGreen
            }
            
            let usdAmountText = String(format: "%.2f", userTransaction.usdAmount)
            let lbpAmountText = String(format: "%.2f", userTransaction.lbpAmount)
            
            let arrowImageAttachment = NSTextAttachment()
            let arrowImage = UIImage(systemName: "arrow.left.arrow.right")?.withTintColor(.label)
            arrowImageAttachment.image = arrowImage

            let fullString = NSMutableAttributedString(string: "USD\(usdAmountText) ")
            fullString.append(NSAttributedString(attachment: arrowImageAttachment))
            fullString.append(NSAttributedString(string: " LBP\(lbpAmountText)"))
            cell.rateLabel.attributedText = fullString
            
            dateFormatter.dateFormat = "dd MMM yyyy"
            let date = dateFormatter.date(from: userTransaction.addedDate)!

            dateFormatter.dateFormat = "MMM d yyyy"
            cell.dateLabel.text = dateFormatter.string(from: date)
            
            cell.secondUserLabel.text = "exchanged with @\(userTransaction.userName)"
            
            return cell
        }
        
        
    }
}


// MARK: Targets + Actions
extension DetailedStatisticsViewController {
    private func setupTargets() {
        statisticsView.daysSegmentedControl.addTarget(self, action: #selector(changedDays(_:)), for: .valueChanged)
        statisticsView.segmentedControl.addTarget(self, action: #selector(changedFilter(_:)), for: .valueChanged)
    }
    
    @objc private func changedDays(_ sender: UISegmentedControl) {
        fetchStatistics()
    }
    
    @objc private func changedFilter(_ sender: UISegmentedControl) {
        fetchTableData()
    }
}


// MARK: Statistics
extension DetailedStatisticsViewController {
    private func fetchStatistics() {
        let days: Int = 90 / (statisticsView.daysSegmentedControl.selectedSegmentIndex+1)
        
        voyage.get(with: URL(string: "\(K.url)/stats/\(days)")!,
                   completion: didFetchStatistics(statistics:),
                   fail: failFetchStatistics(error:),
                   bearerToken: authentication.getToken())
    }
    
    private func didFetchStatistics(statistics: Statistics) {
        statisticsView.sellUsdLabels[1].text = String(format: "Max: %.2f", statistics.maxUsdToLbp)
        statisticsView.sellUsdLabels[2].text = String(format: "Med: %.2f", statistics.medianUsdToLbp)
        statisticsView.sellUsdLabels[3].text = String(format: "Stdev: %.2f", statistics.stdevUsdToLbp)
        
        statisticsView.buyUsdLabels[1].text = String(format: "Max: %.2f", statistics.maxLbpToUsd)
        statisticsView.buyUsdLabels[2].text = String(format: "Med: %.2f", statistics.medianLbpToUsd)
        statisticsView.buyUsdLabels[3].text = String(format: "Stdev: %.2f", statistics.stdevLbpToUsd)
    }
    
    private func failFetchStatistics(error: Error) {
        print("Failed to fetch statistics: \(error)")
    }
}


// MARK: Transactions
extension DetailedStatisticsViewController {
    private func fetchTransactions() {
        voyage.get(with: URL(string: "\(K.url)/transaction")!,
                   completion: didFetchTransactions(transactions:),
                   fail: failFetchTransactions(error:),
                   bearerToken: authentication.getToken())
    }
    
    private func didFetchTransactions(transactions: [Transaction]) {
        self.transactions = transactions
        self.userTransactions = []
        tableView.reloadData()
    }
    
    private func failFetchTransactions(error: Error) {
        print("Failed to fetch past transactions: \(error)")
    }
}


// MARK: User Transactions
extension DetailedStatisticsViewController {
    private func fetchUserTransactions() {
        voyage.get(with: URL(string: "\(K.url)/userTransactions")!,
                   completion: didFetchUserTransactions(userTransactions:),
                   fail: failFetchTransactions(error:),
                   bearerToken: authentication.getToken())
    }
    
    private func didFetchUserTransactions(userTransactions: [UserTransaction]) {
        self.userTransactions = userTransactions
        self.transactions = []
        tableView.reloadData()
    }
}
