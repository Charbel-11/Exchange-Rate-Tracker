//
//  ImageLabel.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/30/21.
//

import UIKit

class ImageLabel: UIControl {
    
    let label = UILabel()
    let image = UIImageView()
    let axis: NSLayoutConstraint.Axis

    init(axis: NSLayoutConstraint.Axis = .horizontal) {
        self.axis = axis
        super.init(frame: .zero)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [image, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.spacing = 5
        stack.alignment = .center
        
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
}
