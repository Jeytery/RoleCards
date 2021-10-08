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
    func push(_ viewController: UIViewController)
    
    func startLoading()
    func stopLoading()
    
    func presenter(didUpdate rooms: Rooms)
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
        nvc.modalPresentationStyle = .overCurrentContext
        delegate.present(nvc)
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
    
    private func add(user: User, to room: Room) {
        
    }
}

//MARK: - [d] userManager
extension MultiplayerViewControllerPresenter: UserManagerDelegate {
    func userManagerDidNotGetUser() {
        ui {
            [unowned self] in
            showAutorize()
        }
    }
    
    func userManagerDidAutorize() { LoadingState.stop() }
    func userManager(didGet user: User) {}
}

//MARK: - [d] autorizationVC
extension MultiplayerViewControllerPresenter: AutorizationViewControllerDelegate {
    func autorizationViewController(_ viewController: UIViewController, didAutorized user: User) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - [d] deckNC
extension MultiplayerViewControllerPresenter: DeckNavigationControllerDelegate {
    func deckNavigationContoller(_ viewController: UIViewController, roles: Roles, room: Room) {
        viewController.dismiss(animated: true, completion: {
            print(room.token)
            let roomVC = RoomViewController(room: room, roles: roles)
            self.delegate.present(roomVC)
        })
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
        var room = rooms[index]
        room.users.append(user)
        updateRoom(room)
        
        //TODO: - show cardViewController
    }
}
