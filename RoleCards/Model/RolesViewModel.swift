//
//  RolesViewModel.swift
//  RoleCards
//
//  Created by Jeytery on 05.10.2021.
//

import Foundation

typealias Roles = [Role]

class RolesViewModel {
    
    private(set) var rolesObservable = Observable<Roles>()
    
    var roles: Roles {
        get { rolesObservable.value ?? [] }
        set { rolesObservable.value = newValue }
    }
    
    private let id = "RoleManager.roles.id"
    private let userDefaults = UserDefaults.standard
    
    init() {
        rolesObservable.value = getRoles() ?? []
    }
}

extension RolesViewModel {
    private func saveRoles() {
        guard let data = try? JSONEncoder().encode(roles) else { return }
        userDefaults.set(data, forKey: id)
    }
    
    func getRoles() -> Roles? {
        guard let data = userDefaults.data(forKey: id),
              let roles = try? JSONDecoder().decode(Roles.self, from: data)
        else { return nil }
        return roles
    }
    
    func saveRole(_ role: Role) {
        roles.append(role)
        saveRoles()
    }
    
    func deleteRole(at: Int) {
        roles.remove(at: at)
        saveRoles()
    }
    
    func updateRole(_ role: Role, at: Int) {
        roles.remove(at: at)
        roles.insert(role, at: at)
        saveRoles()
    }
    
    func clear() {
        userDefaults.removePersistentDomain(forName: id)
        roles = []
    }
}
