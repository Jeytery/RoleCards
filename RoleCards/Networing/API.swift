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

func getUsers(completion: @escaping (Result<Users, Error>) -> Void) {
    let database = Database.database().reference()
    database.child("users").getData(completion: {
        error, dataSnapshot in
        guard let dict = dataSnapshot.value as? [String: Any] else {
            completion(.failure(UsersError.dictionaryCast))
            return
        }
        var users = Array<User>()
        for (_, _value) in dict {
            guard   let value = _value as? [String: Any],
                    let name = value["username"] as? String,
                    let password = value["password"] as? String,
                    let token = value["token"] as? String
            else { return }
            let user = User(username: name,
                            password: password,
                            token: token)
            users.append(user)
        }
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
        var rooms = Rooms()
        for (_, _value) in dict { }
        completion(.success(rooms))
    })
}

func pushRoom(_ room: Room) {
    
}

func updateRoom(_ room: Room) {
    
}

func deleteRoom(_ room: Room) {
    
}


