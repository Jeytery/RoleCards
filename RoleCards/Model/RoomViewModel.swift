//
//  File.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import Foundation
import FirebaseDatabase

class RoomViewModel {
    
    private let roles: Roles
    
    private(set) var room: Room
    
    private var usersObserv = Observable<Users>()
    
    var users: Users {
        get { usersObserv.value ?? [] }
        set { usersObserv.value = newValue }
    }

    init(room: Room, roles: Roles) {
        self.roles = roles
        self.room = room
        configureObservers()
    }
}

//MARK: - internal functions
extension RoomViewModel {
    private func configureObservers() {
        let database = Database.database().reference().child("rooms")
        database.child(room.token).observe(.value, with: {
            dataSnapshot in
            guard let value = dataSnapshot.value as? [String: Any],
                  let usersDict = value["users"] as? [String: Any]
            else { return }
            let users = parseJsonToUsers(usersDict)
            self.users = users
        })
        
        database.child(room.token).observe(.childRemoved, with: {
            value in
            self.users = []
        })
    }
}

//MARK: - public
extension RoomViewModel {
    var playersCount: String {
        return "Players count: \(users.count)/\(String(roles.count))"
    }
    
    func observeUsers(onUpdate: @escaping (Users) -> Void) {
        usersObserv.subscribe(onUpdate: onUpdate)
    }
    
    func sendEvents() {
        let deck = roles.shuffled()
        for i in 0..<users.count {
            let user = users[i]
            addEvent(status: .hasCome,
                     name: .cardDidCome,
                     userId: user.token,
                     message: nil,
                     userInfo: deck[i].dictionary)
        }
    }
    
    func removeRoom() {
        deleteRoom(room)
    }
}
