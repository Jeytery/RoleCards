//
//  UserManager.swift
//  RoleCards
//
//  Created by Jeytery on 01.10.2021.
//

import Foundation

protocol UserManagerDelegate: AnyObject {
    func userManagerDidAutorize()
    func userManager(didGet user: User)
    func userManagerDidNotGetUser()
}

extension UserManagerDelegate {
    func userManagerDidAutorize() {}
}

class UserManager {
        
    static let shared = UserManager()
    
    weak var delegate: UserManagerDelegate?
    
    private(set) var user: User?
    private(set) var isAutorizing = false
    
    private let id: String = "UserManager.user.id"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
}

//MARK: - internal funcs
extension UserManager {
    func saveUser(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else {
            print("saveUser: unavailable to encode user")
            return
        }
        userDefaults.set(data, forKey: id)
    }
    
    func getUser() -> User? {
        guard let data = userDefaults.data(forKey: id),
              let user = try? JSONDecoder().decode(User.self, from: data)
        else { return nil }
        return user
    }
    
    private func clearUser() {
        userDefaults.removePersistentDomain(forName: id)
    }
}

//MARK: - public
extension UserManager {
    func configure() {
        isAutorizing = true
        guard let _user = getUser() else {
            delegate?.userManagerDidNotGetUser()
            delegate?.userManagerDidAutorize()
            isAutorizing = false
            return
        }
        
        checkIsUserValid(token: _user.token, completion: {
            [unowned self] result in
            isAutorizing = false
            delegate?.userManagerDidAutorize()
            
            switch result {
            case .success(let status):
                print(status)
                guard status else {
                    clearUser()
                    delegate?.userManagerDidNotGetUser()
                    return
                }
                delegate?.userManager(didGet: _user)
                user = _user
                break
            case .failure(let error):
                delegate?.userManagerDidNotGetUser()
                print(error)
                break
            }
        })
    }
}
