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
        let multiplayerVC = UINavigationController(rootViewController: MultiplayerViewController())
        setViewControllers([singleplayerVC, multiplayerVC], animated: false)
        
        guard let items = tabBar.items else { return }
        
        let images = [Icons.play, Icons.social]
        
        for i in 0..<items.count {
            let item = items[i]
            item.title = ""
            item.image = images[i]
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
