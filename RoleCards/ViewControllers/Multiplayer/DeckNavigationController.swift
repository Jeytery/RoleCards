//
//  DeckNavigationController.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit

protocol DeckNavigationControllerDelegate: AnyObject {
    func deckNavigationContoller(_ viewController: UIViewController, roles: Roles)
}

class DeckNavigationController: BaseNavigationController {
    
    weak var deckDelegate: DeckNavigationControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let playersCountVC = PlayersCountViewController()
        playersCountVC.delegate = self
        setViewControllers([playersCountVC], animated: false)
        
        let doneButton = UIBarButtonItem(image: Icons.exit,
                                         style: .plain,
                                         target: self,
                                         action: #selector(action))
        topViewController?.navigationItem.rightBarButtonItem = doneButton
        doneButton.tintColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - [d] playersCountVC
extension DeckNavigationController: PlayersCountViewControllerDelegate {
    func playersCountViewController(didChoosePlayers count: Int) {
        let deckVC = DeckViewController(playersCount: count)
        deckVC.delegate = self
        pushViewController(deckVC, animated: true)
    }
}

//MARK: - [d] deckVC
extension DeckNavigationController: DeckViewControllerDelegate {
    func deckViewController(_ viewController: UIViewController, didChoose roles: Roles) {
        deckDelegate?.deckNavigationContoller(self, roles: roles)
    }
}
