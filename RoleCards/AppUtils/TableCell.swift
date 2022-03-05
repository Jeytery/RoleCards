//
//  TableCell.swift
//  RoleCards
//
//  Created by Jeytery on 01.03.2022.
//

import UIKit

class TableCell<T: UIView>: UITableViewCell {
    
    var baseView: T!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView(T())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(_ _view: T) {
        self.baseView = _view
        contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        baseView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        baseView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
