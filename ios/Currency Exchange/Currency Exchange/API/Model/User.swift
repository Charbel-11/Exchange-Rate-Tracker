//
//  User.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/9/21.
//

import Foundation

struct User: Codable {
    var id: Int? = nil
    let username: String
    let password: String
}
