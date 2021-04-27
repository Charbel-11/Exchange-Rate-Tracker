//
//  AuthenticationViewController.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/7/21.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    let cancelButton = UIButton()
    let usernameTextField = BoldBorderlessTextField(placeholder: "Username")
    let passwordTextField = BoldBorderlessTextField(placeholder: "Password")
    let submitButton = FilledButton(textColor: .white, backgroundColor: .systemOrange)
    
    var submitAction: ((User) -> Void)?
    var submitTitle: String?
    
    init(submitAction: @escaping(User) -> Void, submitTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.submitAction = submitAction
        self.submitTitle = submitTitle
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


extension AuthenticationViewController {
    private func setupSubviews() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill")!.withConfiguration(UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        cancelButton.tintColor = .secondaryLabel
        
        usernameTextField.setupForUsernameContent()
        
        passwordTextField.setupForPasswordContent()
        
        submitButton.setTitle(submitTitle, for: .normal)
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            passwordTextField,
            submitButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.setCustomSpacing(40, after: passwordTextField)
        
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


extension AuthenticationViewController {
    private func setupTargets() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func submitTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        let user = User(username: username, password: password)
        submitAction?(user)
    }
}
