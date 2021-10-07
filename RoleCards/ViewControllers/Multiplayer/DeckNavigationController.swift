//
//  DeckNavigationController.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit

protocol DeckNavigationControllerDelegate: AnyObject {
    func deckNavigationContoller(_ viewController: UIViewController,
                                 roles: Roles,
                                 room: Room)
}

class DeckNavigationController: BaseNavigationController {
    
    weak var deckDelegate: DeckNavigationControllerDelegate?
    
    private var roomName: String = "Unnamed room"
    private var roomPassword: String = ""
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let deckInfoVC = DeckInfoViewController()
        deckInfoVC.delegate = self
        setViewControllers([deckInfoVC], animated: false)
        
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

//MARK: - [d] deckInfoVC
extension DeckNavigationController: DeckInfoViewControllerDelegate {
    func deckInfoViewController(_ viewController: UIViewController, didDismissWith name: String, password: String) {
        roomName = name
        roomPassword = password
        let playersCountVC = PlayersCountViewController()
        playersCountVC.delegate = self
        pushViewController(playersCountVC, animated: true)
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
        let room = Room(name: roomName,
                        token: UUID().uuidString,
                        users: [],
                        creator: UserManager.shared.user!,
                        password: roomPassword)
        pushRoom(room)
        deckDelegate?.deckNavigationContoller(self, roles: roles, room: room)
    }
}

