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
    let maxUserCount: Int
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
            "maxUserCount": maxUserCount,
            "password": password ?? ""
        ]
    }
    
    func dictionary(token: String) -> [String: Any] {
        return [
            "name": name,
            "users": getUsers(),
            "token": token,
            "creator": creator.dictionary,
            "maxUserCount": maxUserCount,
            "password": password ?? ""
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
        maxUserCount = json["maxUserCount"] as? Int ?? 0
        password = json["password"] as? String ?? ""
    }
    
    init(name: String, token: String, users: Users, creator: User, maxUserCount: Int, password: String) {
        self.name = name
        self.token = token
        self.users = users
        self.password = password
        self.creator = creator
        self.maxUserCount = maxUserCount
    }
}
