//
//  RoleCountView.swift
//  RoleCards
//
//  Created by Jeytery on 03.03.2022.
//

import UIKit

protocol RoleCountViewDelegate: AnyObject {
    func roleCountView(_ view: RoleCountView, didChange count: Int, of role: Role)
}

class RoleCountView: UIView {
    
    weak var delegate: RoleCountViewDelegate?
    
    private let stepper = Stepper(style: .dark)
    private let circleRoleView = CircleRoleView()
    private let roleNameLabel = UILabel()
    
    private let maxValue = 99
    private let minValue = 0
    
    private var role: Role!
    
    init() {
        super.init(frame: .zero)
        configureStepper()
        configureNameLabel()
        configureCircleRoleView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setRole(_ role: Role) {
        self.role = role
        circleRoleView.setRole(role)
        roleNameLabel.text = role.name
    }
    
    func setCount(_ count: Int) {
        let _count = Double(count)
        stepper.setValue(_count)
    }
}

extension RoleCountView {
    private func configureStepper() {
        addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stepper.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stepper.widthAnchor.constraint(equalToConstant: 120).isActive = true
        stepper.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        stepper.maxValue = Double(maxValue)
        stepper.minValue = Double(minValue)
        
        stepper.delegate = self
    }
   
    private func configureNameLabel() {
        addSubview(circleRoleView)
        circleRoleView.translatesAutoresizingMaskIntoConstraints = false
        circleRoleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circleRoleView.heightAnchor.constraint(equalToConstant: 39).isActive = true
        circleRoleView.widthAnchor.constraint(equalToConstant: 39).isActive = true
        circleRoleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
    }
    
    private func configureCircleRoleView() {
        roleNameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(roleNameLabel)
        roleNameLabel.translatesAutoresizingMaskIntoConstraints = false
        roleNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        roleNameLabel.leftAnchor.constraint(equalTo: circleRoleView.rightAnchor, constant: 15).isActive = true
        roleNameLabel.rightAnchor.constraint(equalTo: stepper.leftAnchor, constant: -15).isActive = true
    }
}

extension RoleCountView: StepperDelegate {
    func stepper(_ stepper: Stepper, didChange value: Double) {
        delegate?.roleCountView(self, didChange: Int(value), of: role)
    }
}
