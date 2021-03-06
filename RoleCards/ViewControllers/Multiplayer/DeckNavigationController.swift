//
//  DeckNavigationController.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit
import FirebaseDatabase

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
        let deckInfoVC = DeckInfoViewController()
        super.init(rootViewController: deckInfoVC, buttonSide: .right, withBigTitle: false)
        deckInfoVC.delegate = self
        setViewControllers([deckInfoVC], animated: false)
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
        let deckVC = DeckListViewController(playersCount: count)
        deckVC.delegate = self
        pushViewController(deckVC, animated: true)
    }
}

//MARK: - [d] deckVC
extension DeckNavigationController: DeckListViewControllerDelegate {
    func deckViewController(_ viewController: UIViewController, didChoose roles: Roles) {
        let database = Database.database().reference().child("rooms")
        guard let key = database.childByAutoId().key else { return }
        let room = Room(name: roomName,
                        token: key,
                        users: [],
                        creator: UserManager.shared.user ?? User(username: "", password: "", token: ""),
                        maxUserCount: roles.count,
                        roles: roles,
                        password: roomPassword)
        
        database.child(key).setValue(room.dictionary)
        UserManager.shared.addActiveRoom(room)
        deckDelegate?.deckNavigationContoller(self, roles: roles, room: room)
    }
}

