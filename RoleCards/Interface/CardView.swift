//
//  CardView.swift
//  RoleCards
//
//  Created by Jeytery on 08.10.2021.
//

import UIKit

class CardView: UIView {
    
    private var isFliped: Bool = false
    private let role: Role
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    
    
    private let flipColor = Colors.lightGray
    
    init(role: Role) {
        self.role = role
        super.init(frame: .zero)
        backgroundColor = Colors.green
        configureUI()
        configureImage()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - internal
extension CardView {
    private func configureImage() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bigsur")
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.layer.cornerRadius = DesignProperties.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    private func configureUI() {
        addSubview(nameLabel)
        nameLabel.text = role.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        layer.cornerRadius = DesignProperties.cornerRadius
        nameLabel.isHidden = !isFliped
        nameLabel.textColor = Luma.blackOrWhite(role.color.uiColor)
    }
    
    private func addTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture)))
    }
    
    @objc func tapGesture() {
        isFliped = !isFliped
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: nil,
                          completion: nil)
        backgroundColor = isFliped ? role.color.uiColor : Colors.green
        nameLabel.isHidden = !isFliped
        imageView.isHidden = isFliped
    }
}
