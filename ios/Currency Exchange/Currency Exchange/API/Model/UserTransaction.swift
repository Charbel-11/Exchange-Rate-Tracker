//
//  UserTransaction.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 5/7/21.
//

import Foundation

struct UserTransaction: Codable {
    let userName: String
    let usdAmount: Float
    let lbpAmount: Float
    let usdToLbp: Bool
    let addedDate: String
}
