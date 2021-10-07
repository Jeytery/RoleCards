//
//  UserCell.swift
//  RoleCards
//
//  Created by Jeytery on 07.10.2021.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    private let indexLabel = UILabel()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.interface
        layer.cornerRadius = DesignProperties.cornerRadius
        
        indexLabel.font = .systemFont(ofSize: 17, weight: .regular)
        nameLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(indexLabel)
        stackView.addArrangedSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setUser(_ user: User, index: Int) {
        indexLabel.text = "Player \(index + 1):"
        nameLabel.text = user.username
    }
}
