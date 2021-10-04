//
//  RoleManager.swift
//  RoleCards
//
//  Created by Jeytery on 03.10.2021.
//

import Foundation

typealias Roles = [Role]

class RoleManager {
    
    static let shared = RoleManager()

    private(set) var roles: Roles!
    
    private let id = "RoleManager.roles.id"
    private let userDefaults = UserDefaults.standard
    
    private init() { roles = getRoles() ?? [] }
}

//MARK: - internal funcs
extension RoleManager {
    func getRoles() -> Roles? {
        guard let data = userDefaults.data(forKey: id),
              let roles = try? JSONDecoder().decode(Roles.self, from: data)
        else { return nil }
        return roles
    }
    
    func saveRole(_ role: Role) {
        roles.append(role)
        guard let data = try? JSONEncoder().encode(roles) else { return }
        userDefaults.set(data, forKey: id)
    }
    
    func clear() {
        userDefaults.removePersistentDomain(forName: id)
        roles = []  
    }
}


