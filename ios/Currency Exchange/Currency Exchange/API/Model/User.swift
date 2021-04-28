//
//  User.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/9/21.
//

import Foundation

struct UserCredentials: Codable {
    let userName: String
    let password: String
}

struct User: Codable {
    let id: String
    let userName: String
}
