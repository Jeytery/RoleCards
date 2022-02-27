//
//  TabsViewController.swift
//  RoleCards
//
//  Created by Jeytery on 12.10.2021.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {
    
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
        let singleplayerVC = SingleplayerNavigationController()
        let multiplayerVC = BigTitleNavigationController(rootViewController: MultiplayerViewController())
        
        setViewControllers([singleplayerVC, multiplayerVC], animated: false)
    }

    private func configureIcons() {
        guard let items = tabBar.items else { return }
        
        let images = [Icons.play, Icons.social]
        for i in 0..<items.count {
            let item = items[i]
            item.title = ""
            item.image = images[i]
        }
        
        tabBar.items?.forEach() {
            $0.imageInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2);
        }
    }
    
    private func configureColors() {
        //UITabBar.appearance().layer.borderWidth = 0.0
        //UITabBar.appearance().clipsToBounds = true
        //tabBar.barTintColor = Colors.interface
        tabBar.tintColor = Colors.tabBar
    }
}
