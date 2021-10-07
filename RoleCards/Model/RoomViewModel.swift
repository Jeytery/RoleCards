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
    
    private let room: Room
    
    private var usersObserv = Observable<Users>()
    
    private lazy var database = Database.database().reference().child("rooms").child(room.token)
        
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
}
