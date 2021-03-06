//
//  Colors.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit

class Colors {
    
    static let lightGray = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    static let green = UIColor(red: 61/255, green: 227/255, blue: 105/255, alpha: 1)
    static let red = UIColor(red: 255/255, green: 61/255, blue: 61/255, alpha: 1)
    static let blue = UIColor(red: 68/255, green: 119/255, blue: 249/255, alpha: 1)
    static let orange = UIColor(red: 252/255, green: 118/255, blue: 45/255, alpha: 1)
    static let purple = UIColor(red: 239/255, green: 92/255, blue: 255/255, alpha: 1)
    
    static var primary: UIColor {
        guard #available(iOS 11.0, *) else { return Colors.blue }
        return UIColor(named: "PrimaryColor")!
    }
        
    static var interface: UIColor {
        guard #available(iOS 11.0, *) else { return Colors.lightGray }
        return UIColor(named: "InterfaceColor")!
    }
    
    static var background: UIColor {
        guard #available(iOS 11.0, *) else { return .white }
        return UIColor(named: "BackgroundColor")!
    }
    
    static var text: UIColor {
        guard #available(iOS 11.0, *) else { return .black }
        return UIColor(named: "TextColor")!
    }
    
    static var secondaryInterface: UIColor {
        guard #available(iOS 11.0, *) else { return .black }
        return UIColor(named: "SecondaryInterfaceColor")!
    }
    
    static var navigation: UIColor {
        guard #available(iOS 11.0, *) else { return Colors.lightGray }
        return UIColor(named: "NavigationColor")!
    }
    
    static var tabBar: UIColor {
        guard #available(iOS 11.0, *) else { return .black }
        return UIColor(named: "TabBarTintColor")!
    }
    
    static let patColors: [UIColor] = [
        Colors.blue,
        Colors.red,
        Colors.green,
        Colors.orange,
        Colors.purple
    ]
}

