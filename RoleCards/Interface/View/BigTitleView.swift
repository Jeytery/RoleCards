//
//  BigTitleView.swift
//  RoleCards
//
//  Created by Jeytery on 08.10.2021.
//

import UIKit

class BigTitleView: UIView {
    
    init(firstTitle: String, secondTitle: String) {
        super.init(frame: .zero)
        let smallTitle = UILabel()
        smallTitle.font = .systemFont(ofSize: 20, weight: .semibold)
        smallTitle.textColor = .gray
        let bigTitle = UILabel()
        bigTitle.font = .systemFont(ofSize: 50, weight: .semibold)
        let stackView = UIStackView()
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        stackView.addArrangedSubview(smallTitle)
        stackView.addArrangedSubview(bigTitle)
        
        smallTitle.text = firstTitle
        bigTitle.text = secondTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
