//
//  StateCollectionView.swift
//  RoleCards
//
//  Created by Jeytery on 03.10.2021.
//

import UIKit

class StateCollectionView: UICollectionView {

    private let imageView = UIImageView()
    
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
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = Colors.background
        
        addSubview(imageView)
        imageView.image = Icons.noResults
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -bottomIndentValue - 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 145).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .gray
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.text = "No results..."
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setState() {
        imageView.isHidden = false
        titleLabel.isHidden = false
    }
    
    private func popState() {
        imageView.isHidden = true
        titleLabel.isHidden = true
    }
}

