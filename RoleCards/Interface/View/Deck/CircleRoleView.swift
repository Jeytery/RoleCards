//
//  CircleRoleView.swift
//  RoleCards
//
//  Created by Jeytery on 01.03.2022.
//

import UIKit

class CircleRoleView: UIView {
    
    private let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.font = .systemFont(ofSize: 10, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        label.font = .systemFont(ofSize: frame.height / 3, weight: .bold)
    }
    
    func setRole(_ role: Role) {
        let color = role.color.uiColor
        backgroundColor = color
        label.text = String(role.name[role.name.startIndex])
        label.textColor = Luma.blackOrWhite(color)
    }
    
    func popRole() {
        backgroundColor = .clear
        label.text = ""
    }
}
