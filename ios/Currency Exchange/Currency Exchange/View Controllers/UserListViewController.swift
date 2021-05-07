//
//  UserListViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 5/7/21.
//

import UIKit

class UserListViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var users = [User]()
    
    let voyage = Voyage()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Send to User"
        
        setupTableView()
        fetchUsers()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.userName
        
        return cell
    }
}


// MARK: Delegate
extension UserListViewController: UITableViewDelegate {
    
}


// MARK: Networking
extension UserListViewController {
    private func fetchUsers() {
        voyage.get(with: URL(string: "\(K.url)/users")!,
                   completion: didFetchUsers(users:),
                   fail: failFetchUsers(error:))
    }
    
    private func didFetchUsers(users: [User]) {
        self.users = users
        tableView.reloadData()
    }
    
    private func failFetchUsers(error: Error) {
        print("Failed to fetch users: \(error)")
    }
}
