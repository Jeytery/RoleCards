//
//  Design.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit

extension UITextField {
    func setStandsrtStyle() {
        layer.masksToBounds = true
        backgroundColor = Colors.interface
        textColor = Colors.text
        borderStyle = .roundedRect
        layer.cornerRadius = DesignProperties.cornerRadius
        clearButtonMode = .whileEditing
        layer.borderWidth = 1
        layer.borderColor = Colors.interface.cgColor
    }
}

extension UIButton {
    func setPrimaryStyle() {
        
    }
    
    func setPrimaryStyle(icon: UIImage, color: UIColor) {
        layer.cornerRadius = DesignProperties.cornerRadius
        backgroundColor = color
        
    }
}

class DesignProperties {
    static let cornerRadius: CGFloat = 10
}

