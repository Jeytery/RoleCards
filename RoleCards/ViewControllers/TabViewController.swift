//
//  TabsViewController.swift
//  RoleCards
//
//  Created by Jeytery on 12.10.2021.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {
    
    private let icons = [Icons.play, Icons.decks, Icons.social]
    
    private let tabControllers = [
        SingleplayerNavigationController(),
        BaseNavigationController(rootViewController: DecksViewController(), buttonSide: .dontShow, withBigTitle: true),
        BaseNavigationController(rootViewController: MultiplayerViewController(), buttonSide:.dontShow, withBigTitle: true)
    ]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViewControllers()
        configureIcons()
        configureColors()
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ui
extension TabViewController {
    private func configureViewControllers() {
        setViewControllers(tabControllers, animated: false)
    }

    private func configureIcons() {
        guard let items = tabBar.items else { return }
        for i in 0..<items.count {
            let item = items[i]
            item.title = ""
            item.image = icons[i]
        }
        
        tabBar.items?.forEach() {
            $0.imageInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2);
        }
    }
    
    private func configureColors() {
        tabBar.tintColor = Colors.tabBar
    }
}
