//
//  Role.swift
//  RoleCards
//
//  Created by Jeytery on 03.10.2021.
//

import CoreGraphics

struct RoleColor: Codable {
    let red: CGFloat
    let blue: CGFloat
    let green: CGFloat
}

struct Role: Codable {
    let name: String
    let color: RoleColor
    let description: String
}

