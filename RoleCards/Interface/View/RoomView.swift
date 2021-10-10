//
//  RoomView.swift
//  RoleCards
//
//  Created by Jeytery on 03.10.2021.
//

import UIKit

class RoomView: UIView {
    
    var room: Room! {
        didSet {
            nameLabel.text = room.name
            countLabel.text = String(room.users.count) + "/\(room.maxUserCount)"
            if room.password == "" { lockImageView.isHidden = true }
            else { lockImageView.isHidden = false }
        }
    }
    
    private let nameLabel = UILabel()
    private let countLabel = UILabel()
    private let lockImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RoomView {
    private func setLabel(label: UILabel) {
        label.textColor = Colors.secondaryInterface
        label.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureUI() {
        backgroundColor = Colors.interface
        layer.cornerRadius = DesignProperties.cornerRadius
        setLabel(label: nameLabel)
        setLabel(label: countLabel)
        lockImageView.image = Icons.lock
        lockImageView.tintColor = Colors.primary
        lockImageView.contentMode = .scaleAspectFit
        
        addSubview(lockImageView)
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        lockImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        lockImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lockImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        lockImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.rightAnchor.constraint(equalTo: lockImageView.leftAnchor, constant: -10).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(countLabel)
    }
}
