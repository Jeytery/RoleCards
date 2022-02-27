//
//  StateCollectionView.swift
//  RoleCards
//
//  Created by Jeytery on 03.10.2021.
//

import UIKit

class StateCollectionView: UICollectionView {
    
    private let titleLabel = UILabel()
    
    override func reloadData() {
        super.reloadData()
        if numberOfItems(inSection: 0) == 0 {
            setState()
        }
        else {
            popState()
        }
    }
    
    init(title: String) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = Colors.background
        setTitleLabel(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTitleLabel(title: String) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .gray
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
    }
    
    private func setState() {
        titleLabel.isHidden = false
    }
    
    private func popState() {
        titleLabel.isHidden = true
    }
}

