//
//  DeckView.swift
//  RoleCards
//
//  Created by Jeytery on 01.03.2022.
//

import UIKit

class DeckView: UIView {
    
    private let nameLabel = UILabel()
    private let mainStackView = UIStackView()
    private let circleRolesView = CircleRolesView()
    
    init() {
        super.init(frame: .zero)
        configureMainStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DeckView {
    private func configureMainStackView() {
        addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 7
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        nameLabel.text = "Unnamed Deck"
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        circleRolesView.translatesAutoresizingMaskIntoConstraints = false
        circleRolesView.heightAnchor.constraint(equalTo: circleRolesView.circleViews[0].widthAnchor).isActive = true
        
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(circleRolesView)
    }
    
    func setDeck(_ deck: Deck) {
        nameLabel.text = deck.name
        circleRolesView.setRoles(deck.roles)
        if deck.roles.isEmpty {
            circleRolesView.removeFromSuperview()
        }
        else {
            mainStackView.addArrangedSubview(circleRolesView)
        }
    }
}
