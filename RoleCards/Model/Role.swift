//
//  Role.swift
//  RoleCards
//
//  Created by Jeytery on 03.10.2021.
//

import CoreGraphics
import UIKit

struct RoleColor: Codable {
    let red: CGFloat
    let blue: CGFloat
    let green: CGFloat
    
    var uiColor: UIColor { return UIColor(red: red, green: green, blue: blue, alpha: 1) }
}

struct Role: Codable {
    var name: String
    var color: RoleColor
    var description: String
}

