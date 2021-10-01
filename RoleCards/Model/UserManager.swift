//
//  UserManager.swift
//  RoleCards
//
//  Created by Jeytery on 01.10.2021.
//

import Foundation

protocol UserManagerDelegate: AnyObject {
    
}

class UserManager {
    static let current = UserManager()
}
