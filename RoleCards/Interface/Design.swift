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
    func setPrimaryStyle(title: String = "") {
        backgroundColor = Colors.primary
        layer.cornerRadius = DesignProperties.cornerRadius
        setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    func setPrimaryStyle(icon: UIImage, color: UIColor, constant: CGFloat = 25) {
        layer.cornerRadius = DesignProperties.cornerRadius
        backgroundColor = color
        let imageView = UIImageView()
        imageView.image = icon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: constant).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: constant).isActive = true
        imageView.contentMode = .scaleAspectFit
        tintColor = .white
    }
}

class DesignProperties {
    static let cornerRadius: CGFloat = 13
}

