//
//  RoleView.swift
//  RoleCards
//
//  Created by Jeytery on 04.10.2021.
//

import UIKit

class RoleView: UIView {
    
    private let nameLabel = UILabel()
    private let colorView = UIView()
    private let iconLabel = UILabel()
      
    init() {
        super.init(frame: .zero)
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        nameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.rightAnchor.constraint(equalTo: rightAnchor, constant:  -10).isActive = true
        colorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorView.layer.cornerRadius = 25
        
        colorView.addSubview(iconLabel)
        iconLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor).isActive = true
        iconLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor).isActive = true
        
        backgroundColor = Colors.interface
        layer.cornerRadius = DesignProperties.cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRole(_ role: Role) {
        nameLabel.text = role.name
        colorView.backgroundColor = UIColor(red: role.color.red,
                                            green: role.color.green,
                                            blue: role.color.blue,
                                            alpha: 1)
        iconLabel.text = String(role.name[role.name.startIndex])
    }
}
