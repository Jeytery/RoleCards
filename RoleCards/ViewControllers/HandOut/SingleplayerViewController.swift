//
//  SingleplayerViewController.swift
//  RoleCards
//
//  Created by Jeytery on 12.10.2021.
//

import UIKit

class SingleplayerNavigationController: BigTitleNavigationController {

    init() {
        super.init(nibName: nil, bundle: nil)
        let playersCountVC = PlayersCountViewController()
        title = "Player count"
        playersCountVC.delegate = self
        
        let mixerVC = MixerViewController()
        setViewControllers([mixerVC], animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - playersCountVC
extension SingleplayerNavigationController: PlayersCountViewControllerDelegate {
    func playersCountViewController(didChoosePlayers count: Int) {
        let deckVC = DeckViewController(playersCount: count)
        deckVC.delegate = self
        pushViewController(deckVC, animated: true)
    }
}

//MARK: - deckVC
extension SingleplayerNavigationController: DeckViewControllerDelegate {
    func deckViewController(_ viewController: UIViewController, didChoose roles: Roles) {
        let cardsVC = CardsStackViewController(roles: roles.shuffled())
        let nvc = BaseNavigationController(rootViewController: cardsVC)
        present(nvc, animated: true, completion: nil)
    }
}
