//
//  InsetsTableCell.swift
//  RoleCards
//
//  Created by Jeytery on 04.03.2022.
//

import UIKit

class InsetsTableCell<BaseView: UIView>: UITableViewCell {
    
    var baseView: BaseView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView(BaseView())
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setView(_ _view: BaseView) {
        self.baseView = _view
        contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        baseView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        baseView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
    }
}
