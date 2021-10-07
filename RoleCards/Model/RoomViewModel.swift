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
    
    private var playersObserv = Observable<Users>()
        
    var players: Users {
        get { playersObserv.value ?? [] }
        set { playersObserv.value = newValue }
    }
    
    init(roles: Roles) {
        self.roles = roles
    }
    
}

//MARK: - internal functions
extension RoomViewViewModel {
}

//MARK: - public
extension RoomViewViewModel {
    var playersCount: String {
        return "Players count: \(players.count)/\(String(roles.count))"
    }
}
