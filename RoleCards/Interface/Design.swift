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
        let lightGrey = Colors.lightGray
        backgroundColor = lightGrey
        textColor = .black
        borderStyle = .roundedRect
        layer.cornerRadius = DesignProperties.cornerRadius
        clearButtonMode = .whileEditing
        layer.borderWidth = 1
        layer.borderColor = lightGrey.cgColor
    }
}

extension UIButton {
    func setStandartStyle(icon: UIImage, color: UIColor) {
        layer.cornerRadius = DesignProperties.cornerRadius
        backgroundColor = color
    }
    
    func setStandartStyle() {
        
    }
}

class DesignProperties {
    static let primaryColor: UIColor = .blue
    static let secondaryColor: UIColor = .gray
    static let cornerRadius: CGFloat = 10
}

