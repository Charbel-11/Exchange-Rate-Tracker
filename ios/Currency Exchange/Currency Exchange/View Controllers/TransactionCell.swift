//
//  TransactionCell.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/29/21.
//

import UIKit

class TransactionCell: UITableViewCell {
    static var reuseIdentifier = "transactionCell"
    
    let wrapper = UILabel()
    let exchangeTypeLabel = UILabel()
    let rateLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor = .systemGreen
        wrapper.layer.cornerRadius = 5
        wrapper.layer.masksToBounds = true
        
        exchangeTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeTypeLabel.font = .preferredFont(forTextStyle: .caption2)
        exchangeTypeLabel.textColor = .white
        exchangeTypeLabel.text = "BUY USD"
        
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.numberOfLines = 1
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.circle")

        let fullString = NSMutableAttributedString(string: "Press the ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " button"))
        rateLabel.attributedText = fullString
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.numberOfLines = 1
        dateLabel.text = "January 21 2021"
    }
    
    private func setupLayout() {
        wrapper.addSubview(exchangeTypeLabel)
        NSLayoutConstraint.activate([
            exchangeTypeLabel.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 3),
            exchangeTypeLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 3),
            exchangeTypeLabel.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -3),
            exchangeTypeLabel.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -3)
        ])
        
        contentView.addSubview(wrapper)
        contentView.addSubview(rateLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            wrapper.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            wrapper.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            rateLabel.topAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: 8),
            rateLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rateLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            dateLabel.centerYAnchor.constraint(equalTo: rateLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
}
