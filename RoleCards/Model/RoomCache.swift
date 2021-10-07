//
//  RoomCache.swift
//  RoleCards
//
//  Created by Jeytery on 07.10.2021.
//

import Foundation
import FirebaseDatabase

class RoomCache {
    
    private let database = Database.database().reference()
    private let userDefaults = UserDefaults.standard
    private let id = "RoomCache.userDefaults.id"
    
    init() {
        
    }
}

//MARK: - internal functions
extension RoomCache {
    private func saveRoom(_ room: Room) {
        var rooms = getRooms()
        rooms.append(room)
        saveRooms(rooms)
    }
    
    private func saveRooms(_ rooms: Rooms) {
        guard let data = try? JSONEncoder().encode(rooms) else { return }
        userDefaults.set(data, forKey: id)
    }
}

//MARK: - public
extension RoomCache {
    func registerRoom(_ room: Room) {
        
    }
    
    func clearRoom(_ room: Room) {
        userDefaults.removePersistentDomain(forName: id)
    }
    
    func getRooms() -> Rooms {
        guard let data = userDefaults.data(forKey: id),
              let rooms = try? JSONDecoder().decode(Rooms.self, from: data)
        else { return [] }
        return rooms
    }
}


/*
 
 let cache = RoomsCache()
 
 cache.delegate = self
 
 func roomsCache(didGetAction: Rooms) {
    let first = rooms[0]
    
 }
 
 
 
 */
