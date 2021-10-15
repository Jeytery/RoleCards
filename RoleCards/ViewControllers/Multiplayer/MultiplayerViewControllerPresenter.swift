//
//  MultiplayerViewControllerPresenter.swift
//  RoleCards
//
//  Created by Jeytery on 07.10.2021.
//

import Foundation
import UIKit
import FirebaseDatabase

protocol MultiplayerViewControllerPresenterDelegate: AnyObject {
    func present(_ viewController: UIViewController)
    func presentOverCurrentContetext(_ viewController: UIViewController)
    func push(_ viewController: UIViewController)
    
    func startLoading()
    func stopLoading()
    
    func presenter(didUpdate rooms: Rooms)
    
    func showInfoAlert(title: String)
    func showTextFieldAlert(onDone: @escaping (String) -> Void)
}

class MultiplayerViewControllerPresenter {
    
    unowned let delegate: MultiplayerViewControllerPresenterDelegate

    private var roomsObserver = Observable<Rooms>()
    
    private let database = Database.database().reference().child("rooms")
    
    init(with delegate: MultiplayerViewControllerPresenterDelegate) {
        self.delegate = delegate
        configureObserver()
        configureUserManager()
        configureRooms()
    }
}

//MARK: - internal functions
extension MultiplayerViewControllerPresenter {
    private func configureObserver() {
        database.observe(.value, with: {
            [weak self] datasnapshot in
            guard let dict = datasnapshot.value as? [String: Any] else { return }
            let rooms = parseJsonToRooms(dict)
            self?.rooms = rooms
        })
        
        database.observe(.childRemoved, with: {
            [weak self] _ in
            self?.rooms = []
        })
   
        roomsObserver.subscribe(onUpdate: {
            [weak self] rooms in
            self?.ui { self?.delegate.presenter(didUpdate: rooms) }
        })
    }
    
    private func configureUserManager() {
        delegate.startLoading()
        UserManager.shared.delegate = self
        UserManager.shared.configure()
    }
    
    private func showAutorize() {
        let autorizationVC = AutorizationViewContoller()
        autorizationVC.delegate = self
        let nvc = BigTitleNavigationController(rootViewController: autorizationVC)
        delegate.presentOverCurrentContetext(nvc)
    }
    
    private func ui(action: @escaping () -> Void) {
        DispatchQueue.main.async { action() }
    }
    
    private func configureRooms() {
        getRooms(completion: {
            [weak self] result in
            switch result {
            case .success(let rooms):
                self?.rooms = rooms
                break
            case .failure(let error):
                print("getRooms: \(error)")
                break
            }
        })
    }

    private func checkRoomOverflow(_ room: Room) -> Bool {
        if room.users.count == room.maxUserCount {
            return true
        }
        return false
    }
    
    private func addUserToRoom(_ user: User, _ room: Room) {
        var _room = room
        _room.users.append(user)
        updateRoom(_room)
        let cardVC = CardViewController(room: room)
        cardVC.modalPresentationStyle = .overCurrentContext
        cardVC.delegate = self
        delegate.present(cardVC)
    }
    
    private func checkPassword(_ password: String, user: User, room: Room) {
        delegate.showTextFieldAlert(onDone: {
            [unowned self] text in
            if text == password {
                addUserToRoom(user, room)
            }
            else {
                delegate.showInfoAlert(title: "Room's password is incorrect, try again")
            }
        })
    }
    
    private func showRoomVC(room: Room) {
        let roomVC = RoomViewController(room: room)
        roomVC.delegate = self
        delegate.presentOverCurrentContetext(roomVC)
    }
}


//MARK: - [d] userManager
extension MultiplayerViewControllerPresenter: UserManagerDelegate {
    func userManagerDidNotGetUser() {
        ui { [weak self] in self?.showAutorize() }
    }
    
    func userManagerDidAutorize() {
        LoadingState.stop()
    }
    
    func userManager(didGet user: User) {
        guard let activeRoomToken = user.activeRoomToken, activeRoomToken != "" else { return }
        let database = Database.database().reference().child("rooms")
        database.child(activeRoomToken).getData(completion: {
            [unowned self] error, snapshot in
            guard error == nil, snapshot.hasChildren() else { return }
            guard let value = snapshot.value as? [String: Any] else { return }
            let room = Room(json: value[activeRoomToken] as! [String: Any])
            ui { showRoomVC(room: room) }
        })
    }
}

//MARK: - [d] autorizationVC
extension MultiplayerViewControllerPresenter: AutorizationViewControllerDelegate {
    func autorizationViewController(_ viewController: UIViewController, didAutorized user: User) {
        ui { viewController.navigationController?.dismiss(animated: true, completion: nil) }
    }
}

//MARK: - [d] deckNC
extension MultiplayerViewControllerPresenter: DeckNavigationControllerDelegate {
    func deckNavigationContoller(_ viewController: UIViewController, roles: Roles, room: Room) {
        viewController.dismiss(animated: true, completion: nil)
        showRoomVC(room: room)
    }
}

//MARK: - [d] cardVC
extension MultiplayerViewControllerPresenter: CardViewControllerDelegate {
    func cardViewController(_ viewController: UIViewController, didEndedWith room: Room, role: Role) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func cardViewController(_ viewController: UIViewController, didDismiss room: Room) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - [d] roomVC
extension MultiplayerViewControllerPresenter: RoomViewControllerDelegate {
    func roomViewController(_ viewController: UIViewController, didSendEventsFor room: Room) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func roomViewController(_ viewController: UIViewController, didDelete room: Room) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - public
extension MultiplayerViewControllerPresenter {
    var rooms: Rooms {
        get { roomsObserver.value ?? [] }
        set { roomsObserver.value = newValue }
    }
    
    func addRoomButtonAction() {
        let deckNC = DeckNavigationController()
        deckNC.deckDelegate = self
        delegate.present(deckNC)
    }
    
    func didTapOnRoomCell(index: Int) {
        guard let user = UserManager.shared.user else { return }
        let room = rooms[index]
        guard !checkRoomOverflow(room) else {
            delegate.showInfoAlert(title: "Sorry, but this room is full")
            return
        }
        if let password = room.password, password != "" {
            checkPassword(password, user: user, room: room)
            return
        }
        addUserToRoom(user, room)
    }
}
