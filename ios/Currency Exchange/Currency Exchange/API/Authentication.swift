//
//  Authentication.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/6/21.
//

import Foundation

class Authentication {
    private let userDefaults = UserDefaults.standard
    private var token: String?
    
    init() {
        token = userDefaults.string(forKey: "token")
    }
    
    public func getToken() -> String? {
        return token
    }
    
    public func saveToken(token: String) {
        self.token = token
        userDefaults.set(token, forKey: "token")
    }
    
    public func clearToken() {
        self.token = nil
        userDefaults.removeObject(forKey: "token")
    }
}
