//
//  Room.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

struct Room {
    let name: String
    let token: String
    let users: Users
    let password: String?
    
    var dictionary: [String: Any] {
        return [
            "username": name,
            "users": users,
            "token": token,
            "password": password ?? ""
        ]
    }
}
