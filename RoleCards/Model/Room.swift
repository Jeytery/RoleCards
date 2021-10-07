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
    let creator: User
    let password: String?
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "users": users,
            "token": token,
            "creator": creator,
            "password": password ?? "",
        ]
    }
    
    init(json: [String: Any]) {
        name = json["name"] as? String ?? ""
        token = json["token"] as? String ?? ""
        
        if let userDict = json["creator"] as? [String: Any] {
            creator = parseJsonToUsers(userDict)[0]
        }
        else {
            creator = User(username: "", password: "", token: "")
        }
        
        if let usersDict = json["users"] as? [String: Any] {
            users = parseJsonToUsers(usersDict)
        }
        else {
            users = []
        }
        password = json["password"] as? String ?? ""
    }
    
    init(name: String, token: String, users: Users, creator: User, password: String) {
        self.name = name
        self.token = token
        self.users = users
        self.password = password
        self.creator = creator
    }
}
