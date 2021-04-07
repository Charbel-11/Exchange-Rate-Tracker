//
//  FilledButton.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/6/21.
//

import UIKit

class FilledButton: UIButton {

    init(textColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: .zero)
        
        setTitle("Button", for: .normal)
        
        // set dynamic font
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        let font = UIFont.systemFont(ofSize: size, weight: .bold)
        titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        titleLabel?.adjustsFontForContentSizeCategory = true
        
        setTitleColor(textColor, for: .normal)
        setBackgroundColor(color: backgroundColor, forState: .normal)
        
        // rounded corners
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
