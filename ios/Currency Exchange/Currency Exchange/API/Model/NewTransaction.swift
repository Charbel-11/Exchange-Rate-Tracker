//
//  Transaction.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/28/21.
//

import Foundation

struct NewTransaction: Codable {
    let usdAmount: Float
    let lbpAmount: Float
    let usdToLbp: Bool
}
