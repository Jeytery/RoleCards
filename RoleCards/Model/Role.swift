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
    
    var dictionary: [String: Any] {
        return [
            "red": red,
            "blue": blue,
            "green": green
        ]
    }
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    init(json: [String: Any]) {
        self.red = json["red"] as! CGFloat
        self.green = json["green"] as! CGFloat
        self.blue = json["blue"] as! CGFloat
    }
}

struct Role: Codable {
    var name: String
    var color: RoleColor
    var description: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "color": color.dictionary,
            "description": description
        ]
    }
    
    init(name: String, color: RoleColor, description: String) {
        self.name = name
        self.color = color
        self.description = description
    }
    
    init(json: [String: Any]) {
        self.name = json["name"] as! String
        self.color = RoleColor(json: json["color"] as! [String: Any])
        self.description = json["description"] as! String
    }
}

func parseJsonToRoles(_ json: [String: Any]) -> Roles {
    var roles = Roles()
    for (_, _value) in json {
        guard let value = _value as? [String: Any] else { continue }
        let role = Role(json: value)
        roles.append(role)
    }
    return roles
}
