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
                        token: token,
                        activeRoomToken: value["activeRoomToken"] as? String)
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
            completion(.failure(error))
            break
        }
    })
}

func updateUser(_ user: User) {
    let database = Database.database().reference()
    database.child("users").child(user.token).setValue(user.dictionary)
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
            guard let value = _value as? [String: Any] else { return }
            let room = Room(json: value)
            rooms.append(room)
        }
        completion(.success(rooms))
    })
}

func addRoom(_ room: Room) {
    let database = Database.database().reference().child("rooms")
    guard let key = database.childByAutoId().key else { return }
    database.child(key).setValue(room.dictionary(token: key))
}

func updateRoom(_ room: Room) {
    let database = Database.database().reference().child("rooms")
    database.child(room.token).setValue(room.dictionary)
}

func deleteRoom(_ room: Room) {
    let database = Database.database().reference().child("rooms")
    database.child(room.token).removeValue()
}

func parseJsonToRooms(_ json: [String: Any]) -> Rooms {
    return json.map {
        id, _value in
        guard let value = _value as? [String: Any] else {
            let user = User(username: "", password: "", token: "", activeRoomToken: nil)
            return Room(name: "", token: "", users: [], creator: user, maxUserCount: 0, password: "")
        }
        return Room(json: value)
    }
}

//MARK: - event

typealias Events = Array<Event>

enum EventsError: Error {
    case dictionaryCast
    case eventNotFound
}

func parseJsonToEvents(_ json: [String: Any]) -> Events {
    return json.map {
        id, _value in
        guard let value = _value as? [String: Any] else {
            return Event(token: "", status: .undefined, name: .cardDidCome, userId: nil, message: nil, userInfo: nil)
        }
        return Event(json: value)
    }
}

func getEvents(completion: @escaping (Result<Events, EventsError>) -> Void) {
    let database = Database.database().reference().child("events")
    database.getData(completion: {
        error, dataSnapshot in
        guard error == nil else { return }
        guard let dict = dataSnapshot.value as? [String: Any] else {
            completion(.failure(EventsError.dictionaryCast))
            return
        }
        let events = parseJsonToEvents(dict)
        completion(.success(events))
    })
}

func addEvent(
    status: Event.Status,
    name: Event.Name,
    userId: String?,
    message: String?,
    userInfo: Any?
) {
    let database = Database.database().reference()
    guard let key = database.child("events").childByAutoId().key else { return }
    let event = Event(token: key, status: status, name: name, userId: userId, message: message, userInfo: userInfo)
    database.child("events").child(key).setValue(event.dictionary)
}

func updateEvent(_ event: Event) {
    let database = Database.database().reference()
    database.child("events").child(event.token).setValue(event.dictionary)
}

func removeEvent(token: String) {
    let database = Database.database().reference()
    database.child("events").child(token).removeValue()
}


