//
//  RoomCell.swift
//  RoleCards
//
//  Created by Jeytery on 07.10.2021.
//

import UIKit

class RoomCell: UICollectionViewCell {
    
    var room: Room {
        get { roomView.room }
        set { roomView.room = newValue }
    }
    
    private let roomView = RoomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(roomView)
        roomView.translatesAutoresizingMaskIntoConstraints = false
        roomView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        roomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        roomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
