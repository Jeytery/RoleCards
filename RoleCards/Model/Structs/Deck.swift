//
//  Deck.swift
//  RoleCards
//
//  Created by Jeytery on 02.03.2022.
//

import Foundation

typealias Decks = [Deck]

struct Deck: Codable {
    let name: String
    let roles: Roles
}
