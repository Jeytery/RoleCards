//
//  BaseNavigationControlller.swift
//  RoleCards
//
//  Created by Jeytery on 02.03.2022.
//

import UIKit

class BaseNavigationController: UINavigationController {

    enum ButtonSide {
        case left
        case right
    }
    
    @objc func action() { dismiss(animated: true, completion: nil) }
    
    init(
        rootViewController: UIViewController,
        buttonSide: ButtonSide = .right,
        withBigTitle: Bool = true
    ) {
        super.init(rootViewController: rootViewController)
        configureCloseButton(side: buttonSide)
        if #available(iOS 11.0, *), withBigTitle {
            navigationBar.prefersLargeTitles = true
        }
    }
    
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension BaseNavigationController {
    private func configureCloseButton(side: ButtonSide) {
        let customButton = UIButton()
        customButton.setImage(Icons.cross, for: .normal)
        customButton.addTarget(self, action: #selector(action), for: .touchUpInside)
        let barView = UIBarButtonItem(customView: customButton)
                                      
        barView.customView?.translatesAutoresizingMaskIntoConstraints = false
        barView.customView?.widthAnchor.constraint(equalToConstant: 16).isActive = true
        barView.customView?.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        if side == .right {
            topViewController?.navigationItem.rightBarButtonItem = barView
        }
        else {
            topViewController?.navigationItem.leftBarButtonItem = barView
        }
    }
}
