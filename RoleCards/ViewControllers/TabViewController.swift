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
        
        let singleplayerVC = SingleplayerNavigationController()
        let multiplayerVC = BigTitleNavigationController(rootViewController: MultiplayerViewController())
        
        setViewControllers([singleplayerVC, multiplayerVC], animated: false)
        configureTabBar()
    }
    
    private func configureTabBar() {
        guard let items = tabBar.items else { return }
        let images = [Icons.play, Icons.social]
        for i in 0..<items.count {
            let item = items[i]
            item.title = ""
            item.image = images[i]
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        }
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        tabBar.barTintColor = Colors.interface
        tabBar.tintColor = Colors.tabBar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
