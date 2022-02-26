//
//  CardView.swift
//  RoleCards
//
//  Created by Jeytery on 08.10.2021.
//

import UIKit

class CardView: UIView {
    
    private let mainColor: UIColor!
    
    var isFliped: Bool = false {
        didSet {
            backgroundColor = isFliped ? role.color.uiColor : mainColor
            nameLabel.isHidden = !isFliped
            imageView.isHidden = isFliped
        }
    }
    
    var role: Role
    private let nameLabel = UILabel()
    private let imageView = UIImageView()

    init(role: Role, mainColor: UIColor = .red) {
        self.role = role
        self.mainColor = mainColor
        super.init(frame: .zero)
        configureUI()
        configureImage()
        addTapGesture()
        backgroundColor = mainColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - internal
extension CardView {
    private func configureImage() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    func updateRole(_ role: Role) {
        self.role = role
        nameLabel.text = role.name
        nameLabel.textColor = Luma.blackOrWhite(role.color.uiColor)
    }
}
