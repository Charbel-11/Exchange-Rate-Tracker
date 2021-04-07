//
//  BoldBorderlessTextField.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/6/21.
//

import UIKit

class BoldBorderlessTextField: UITextField {

    init(placeholder: String) {
        super.init(frame: .zero)
        
        let font = UIFont.boldSystemFont(ofSize: 24)
        let attributedString = NSAttributedString(string: placeholder, attributes: [
            .font: font
        ])
        self.attributedPlaceholder = attributedString
        self.font = font
        self.borderStyle = .none
        self.tintColor = .systemGreen
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
