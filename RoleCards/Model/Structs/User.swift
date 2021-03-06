//
//  User.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
    let token: String
    var activeRoomToken: String?
    
    var dictionary: [String: Any] {
        return [
            "username": username,
            "password": password,
            "token": token,
            "activeRoomToken": activeRoomToken ?? ""
        ]
    }
}

