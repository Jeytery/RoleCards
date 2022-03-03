//
//  CircleRolesView.swift
//  RoleCards
//
//  Created by Jeytery on 01.03.2022.
//

import UIKit

class CircleRolesView: UIView {
    
    private let rolesCount = 9
    private let stackView = UIStackView()
    
    private(set) var circleViews: [CircleRoleView] = []
    private var roles: Roles = []
    
    private let overflowNumber = UILabel()
    
    init() {
        super.init(frame: .zero)
        configureStackView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configureStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually

        for _ in 0 ..< rolesCount {
            let circleRoleView = CircleRoleView()
            circleViews.append(circleRoleView)
            stackView.addArrangedSubview(circleRoleView)
        }

        overflowNumber.text = ""
        stackView.addArrangedSubview(overflowNumber)
    }
    
    func setRoles(_ roles: Roles) {
        for i in 0 ..< circleViews.count {
            if i > roles.count - 1 {
                break
            }
            circleViews[i].setRole(roles[i])
        }
        
        if circleViews.count < roles.count {
            let number = roles.count - circleViews.count
            overflowNumber.font = .systemFont(ofSize: 13, weight: .semibold)
            overflowNumber.text = "+" + String(number)
        }
    }
}

