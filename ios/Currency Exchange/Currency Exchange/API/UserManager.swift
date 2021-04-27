//
//  UserManager.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/9/21.
//

import Foundation

class UserManager {
    
    public static func login(user: User, callback: @escaping(Token) -> Void) {
        let urlString = "\(K.url)/authentication"
        
        guard let url = URL(string: urlString) else {
            fatalError("the URL should be correct :)")
        }
        
        var request = URLRequest(url: url)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("ERROR")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        request.httpMethod = "POST"
//        let bodyData = try? JSONSerialization.data(
//            withJSONObject: body,
//            options: []
//        )
//        request.httpBody = bodyData
    }
}
