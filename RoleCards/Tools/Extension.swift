//
//  Extension.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func setLargeTitle() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }
    }
}

extension UIView {
    func setTopConstraint(_ viewController: UIViewController, constant: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        }
        else {
            topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor, constant: constant).isActive = true
        }
    }
    
    func setBottomConstraint(_ viewController: UIViewController, constant: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
        }
        else {
            bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor, constant: constant).isActive = true
        }
    }
    
    func setLeftConstraint(_ viewController: UIViewController, constant: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            leftAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.leftAnchor, constant: constant).isActive = true
        }
        else {
            leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
        }
    }
    
    func setRightConstraint(_ viewController: UIViewController, constant: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            rightAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.rightAnchor, constant: constant).isActive = true
        }
        else {
            rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        }
    }
    
    func setFullScreenConstraints(_ viewController: UIViewController) {
        setTopConstraint(viewController)
        setBottomConstraint(viewController)
        setLeftConstraint(viewController)
        setRightConstraint(viewController)
    }
    
    func setSideConstraints(_ viewController: UIViewController, constant: CGFloat = 0) {
        setLeftConstraint(viewController, constant: constant)
        setRightConstraint(viewController, constant: -constant)
    }
}

extension String {
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
}

extension UICollectionView {
    func registerView<T: UIView>(_ view: T.Type, id: String = "cell") {
        register(BaseCell<T>.self, forCellWithReuseIdentifier: id)
    }
}

extension UIColor {
    var roleColor: RoleColor {
        return RoleColor(red: CIColor(color: self).red,
                         blue: CIColor(color: self).green,
                         green:  CIColor(color: self).blue)
    }
}



class BaseCell<T: UIView>: UICollectionViewCell {
    
    var baseView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView(T())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(_ _view: UIView) {
        self.baseView = _view
        addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        baseView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        baseView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}

class _RoomCell: UICollectionViewCell {
    
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
