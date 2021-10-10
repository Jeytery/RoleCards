//
//  Event.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import Foundation

struct Event {
    enum Status: String {
        case undefined = "0"
        case hasCome = "1"
        case notifed = "2"
        case canceled = "-1"
    }
    
    enum Name: String {
        case cardDidCome = "cardDidCome"
        case noName = ""
    }
    
    let token: String
    let status: Status
    let name: Name
    let userId: String?
    let message: String?
    let userInfo: Any?
    
    init(token: String, status: Status, name: Name, userId: String?, message: String?, userInfo: Any?) {
        self.token = token
        self.status = status
        self.name = name
        self.userId = userId
        self.message = message
        self.userInfo = userInfo
    }
    
    init(json: [String: Any]) {
        self.token = json["token"] as? String ?? ""
        self.status = Status(rawValue: json["status"] as? String ?? "0") ?? .undefined
        self.name = Name(rawValue: json["name"] as? String ?? "0") ?? .noName
        self.userId = json["userId"] as? String ?? nil
        self.message = json["message"] as? String ?? nil
        self.userInfo = json["userInfo"] ?? nil
    }
    
    var dictionary: [String: Any] {
        return [
            "token": token,
            "status": status.rawValue,
            "name": name.rawValue,
            "userId": userId ?? "nil",
            "message": message ?? "nil",
            "userInfo": userInfo ?? "nil"
        ]
    }
    
    func dictionary(token: String) -> [String: Any] {
        return [
            "token": token,
            "status": status.rawValue,
            "name": name.rawValue,
            "userId": userId ?? "nil",
            "message": message ?? "nil",
            "userInfo": userInfo ?? "nil"
        ]
    }
}
