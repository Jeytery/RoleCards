//
//  File.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import Foundation
import FirebaseDatabase

class RoomViewModel {
    
    private(set) var room: Room
    
    private var usersObserv = Observable<Users>()
    
    var users: Users {
        get { usersObserv.value ?? [] }
        set { usersObserv.value = newValue }
    }

    init(room: Room) {
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
        return "Players count: \(users.count)/\(String(room.roles.count))"
    }
    
    func observeUsers(onUpdate: @escaping (Users) -> Void) {
        usersObserv.subscribe(onUpdate: onUpdate)
    }
    
    func sendEvents() {
        let deck = room.roles.shuffled()
        for i in 0..<users.count {
            let user = users[i]
            addEvent(status: .hasCome,
                     name: .cardDidCome,
                     userId: user.token,
                     message: nil,
                     userInfo: deck[i].dictionary)
        }
    }
    
    func sendRoomRemoveEvents() {
        for user in users {
            addEvent(status: .hasCome,
                     name: .roomWasRemoved,
                     userId: user.token,
                     message: nil,
                     userInfo: nil)
        }
    }
    
    func removeRoom() {
        deleteRoom(room)
        UserManager.shared.removeActiveRoom()
    }
}
