//
//  Room.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

struct Room: Codable {
    let name: String
    let token: String
    var users: Users
    let creator: User
    let password: String?
    
    func getUsers() -> [String: Any] {
        var dict = [String: Any]()
        for user in users {
            dict[user.token] = user.dictionary
        }
        return dict
    }
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "users": getUsers(),
            "token": token,
            "creator": creator.dictionary,
            "password": password ?? "",
        ]
    }
    
    func dictionary(token: String) -> [String: Any] {
        return [
            "name": name,
            "users": getUsers(),
            "token": token,
            "creator": creator.dictionary,
            "password": password ?? "",
        ]
    }
    
    init(json: [String: Any]) {
        name = json["name"] as? String ?? ""
        token = json["token"] as? String ?? ""
        
        if let userDict = json["creator"] as? [String: Any],
           let user = parseJsonToUsers(userDict).first
        {
            creator = user
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
