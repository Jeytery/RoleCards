//
//  StateTableView.swift
//  RoleCards
//
//  Created by Jeytery on 27.02.2022.
//

import UIKit

class StateTableView: UITableView {
    
    private let titleLabel = UILabel()
    
    var didReloadData: (() -> Void)? = nil

    init(title: String) {
        if #available(iOS 13.0, *) {
            super.init(frame: .zero, style: .insetGrouped)
        }
        else {
            super.init(frame: .zero, style: .grouped)
        }
        configureTitleLabel(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadData() {
        super.reloadData()
        if numberOfRows(inSection: 0) == 0 {
            setEmptyState()
        }
        else {
            popEmptyState()
        }
        didReloadData?()
    }
    
    override func deleteRows(
        at indexPaths: [IndexPath],
        with animation: UITableView.RowAnimation
    ) {
        super.deleteRows(at: indexPaths, with: animation)
        if numberOfRows(inSection: 0) == 0 {
            setEmptyState()
        }
        else {
            popEmptyState()
        }
        didReloadData?()
    }
}

extension StateTableView {
    private func configureTitleLabel(title: String) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        titleLabel.textColor = .gray
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
    }
    
    func setEmptyState() {
        titleLabel.isHidden = false
    }
    
    func popEmptyState() {
        titleLabel.isHidden = true
    }
}
