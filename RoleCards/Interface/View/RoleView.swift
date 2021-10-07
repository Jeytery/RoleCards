//
//  RoleView.swift
//  RoleCards
//
//  Created by Jeytery on 04.10.2021.
//

import UIKit

protocol RoleViewDelegate: AnyObject {
    func roleView(didTapDeleteWith view: UIView)
    func roleView(didTapEdit view: UIView)
}

class RoleView: UIView {
    
    weak var delegate: RoleViewDelegate?
    
    var isEditing: Bool = false {
        didSet {
            isEditing ? setEditing() : popEditing()
        }
    }
    
    private let nameLabel = UILabel()
    private let colorView = UIView()
    private let iconLabel = UILabel()
    private let editStackView = UIStackView()
      
    init() {
        super.init(frame: .zero)
        backgroundColor = Colors.interface
        layer.cornerRadius = DesignProperties.cornerRadius
        configureNameLabel()
        configureEditStackView()
        configureColorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ui
extension RoleView {
    private func configureIconLabelColor(_ color: RoleColor) {
        iconLabel.textColor = Luma.blackOrWhite(color.uiColor)
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        nameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
    }
    
    private func configureColorView() {
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.rightAnchor.constraint(equalTo: rightAnchor, constant:  -15).isActive = true
        colorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorView.layer.cornerRadius = 25
        
        colorView.addSubview(iconLabel)
        iconLabel.textColor = .black
        iconLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor).isActive = true
        iconLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor).isActive = true
    }
    
    private func configureEditStackView() {
        addSubview(editStackView)
        editStackView.translatesAutoresizingMaskIntoConstraints = false
        editStackView.rightAnchor.constraint(equalTo: rightAnchor, constant:  -15).isActive = true
        editStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        editStackView.widthAnchor.constraint(equalToConstant: 105).isActive = true
        editStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        editStackView.distribution = .fillEqually
        editStackView.spacing = 5
        editStackView.axis = .horizontal
        
        let deleteButton = UIButton()
        let editButton = UIButton()
        
        deleteButton.setPrimaryStyle(icon: Icons.cross, color: Colors.red, constant: 15)
        editButton.setPrimaryStyle(icon: Icons.edit, color: Colors.primary, constant: 15)
        deleteButton.layer.cornerRadius = 25
        editButton.layer.cornerRadius = 25
        
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchDown)
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchDown)
        
        editStackView.addArrangedSubview(editButton)
        editStackView.addArrangedSubview(deleteButton)
        editStackView.isHidden = true
    }
    
    @objc func deleteButtonAction() {
        delegate?.roleView(didTapDeleteWith: self)
    }
    
    @objc func editButtonAction() {
        delegate?.roleView(didTapEdit: self)
    }
}

//MARK: - public
extension RoleView {
    func setRole(_ role: Role) {
        nameLabel.text = role.name
        colorView.backgroundColor = role.color.uiColor
        iconLabel.text = String(role.name[role.name.startIndex])
        configureIconLabelColor(role.color)
    }
    
    func setEditing() {
        colorView.isHidden = true
        editStackView.isHidden = false
    }
    
    func popEditing() {
        colorView.isHidden = false
        editStackView.isHidden = true
    }
}
