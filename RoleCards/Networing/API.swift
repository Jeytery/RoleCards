//
//  API.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import FirebaseDatabase

//MARK: - user
typealias Users = Array<User>

enum UsersError: Error {
    case dictionaryCast
    case userNotFound
}

func parseJsonToUsers(_ json: [String: Any]) -> Users {
    var users: Users = []
    for (_, _value) in json {
        guard let value = _value as? [String: Any],
              let name = value["username"] as? String,
              let password = value["password"] as? String,
              let token = value["token"] as? String
        else { return [] }
        let user = User(username: name,
                        password: password,
                        token: token)
        users.append(user)
    }
    return users
}

func getUsers(completion: @escaping (Result<Users, Error>) -> Void) {
    let database = Database.database().reference()
    database.child("users").getData(completion: {
        error, dataSnapshot in
        guard let dict = dataSnapshot.value as? [String: Any] else {
            completion(.failure(UsersError.dictionaryCast))
            return
        }
        let users = parseJsonToUsers(dict)
        completion(.success(users))
    })
}

func checkIsUserValid(token: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    getUsers(completion: {
        result in
        switch result {
        case .success(let users):
            for _user in users {
                if _user.token == token {
                    completion(.success(true))
                    return
                }
            }
            completion(.success(false))
            break
        case .failure(let error):
            completion(.failure(error))
            break
        }
    })
}

func findUser(token: String, completion: @escaping (Result<User, Error>) -> Void) {
    getUsers(completion: {
        result in
        switch result {
        case .success(let users):
            for user in users {
                if user.token == token {
                    completion(.success(user))
                    return
                }
            }
            completion(.failure(UsersError.userNotFound))
            break
        case .failure(let error):
            print("findUser: error \(error)")
            break
        }
    })
}

func findUser(username: String, completion: @escaping (Result<User, Error>) -> Void) {
    getUsers(completion: {
        result in
        switch result {
        case .success(let users):
            for user in users {
                if user.username == username {
                    completion(.success(user))
                    return
                }
            }
            completion(.failure(UsersError.userNotFound))
            break
        case .failure(let error):
            print("findUser: error \(error)")
            break
        }
    })
}

//MARK: - room

typealias Rooms = Array<Room>

enum RoomError: Error {
    case dictionaryCast
    case roomNotFound
}

func getRooms(completion: @escaping (Result<Rooms, Error>) -> Void) {
    let database = Database.database().reference()
    database.child("rooms").getData(completion: {
        error, dataSnapshot in
        guard let dict = dataSnapshot.value as? [String: Any] else {
            completion(.failure(RoomError.dictionaryCast))
            return
        }
        var rooms: Rooms = []
        
        for (_, _value) in dict {
//            guard   let value = _value as? [String: Any],
//                    let name = value["name"] as? String,
//                    let token = value["token"] as? String,
//                    let _users = value["users"] as? [String: Any]
//            else { return }
//            let password = value["password"] as? String ?? ""
//            let users = parseJsonToUsers(_users)
//            let room = Room(name: name,
//                            token: token,
//                            users: users,
//                            password: password)
            guard let value = _value as? [String: Any] else { return }
            let room = Room(json: value)
            rooms.append(room)
        }
        completion(.success(rooms))
    })
}

func pushRoom(_ room: Room) {
    let database = Database.database().reference()
    database.child("rooms").childByAutoId().setValue(room.dictionary)
}

func updateRoom(_ room: Room) {
    
}

func deleteRoom(_ room: Room) {
    //let database = Database.database().reference()
}

func parseJsonToRooms(_ json: [String: Any]) -> Rooms {
    return json.map {
        id, _value in
        guard let value = _value as? [String: Any] else {
            let user = User(username: "", password: "", token: "")
            return Room(name: "", token: "", users: [], creator: user, password: "")
        }
        return Room(json: value)
    }
}
