//
//  CardViewController.swift
//  RoleCards
//
//  Created by Jeytery on 08.10.2021.
//

import UIKit
import FirebaseDatabase

protocol CardViewControllerDelegate: AnyObject {
    func cardViewController(_ viewController: UIViewController, didEndedWith room: Room, role: Role)
    func cardViewController(_ viewController: UIViewController, didDismiss room: Room)
}

class CardViewController: UIViewController {
    
    weak var delegate: CardViewControllerDelegate?
    
    private var nameTitle: BigTitleView!
    private let dismissButton = UIButton()
    private let waitLabel = UILabel()
    
    private let room: Room
    
    private var role: Role!
    
    init(room: Room) {
        self.room = room
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Colors.background
        
        configureTitles()
        configureWaitLabel()
        configureDismissButton()
        
        configureObserver()
//        let role = Role(name: "Mafia", color: Colors.primary.roleColor, description: "iLoveAnal)")
//        guard let user = UserManager.shared.user else { return }
//        addEvent(status: .hasCome, name: .cardDidCome, userId: user.token, message: nil, userInfo: role.dictionary)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - internal
extension CardViewController {
    private func configureObserver() {
        guard let user = UserManager.shared.user else { return }
        let database = Database.database().reference()
        database.child("events").observe(.value, with: {
            [weak self] snapshot in
            guard let json = snapshot.value as? [String: Any] else { return }
                            
            for (_, _value) in json {
                if  let value = _value as? [String: Any],
                    value["userId"] as! String == user.token,
                    Int(value["status"] as! String) ?? 0 == 1,
                    value["name"] as! String == "cardDidCome"
                        
                {
                    guard let roleJson = value["userInfo"] as? [String: Any] else { return }
                    let role = Role(json: roleJson)
                    self?.showCard(role)
                    self?.role = role
                    removeEvent(token: value["token"] as! String)
                }
            }
        })
    }
}

//MARK: - ui
extension CardViewController {
    private func configureTitles() {
        nameTitle = BigTitleView(firstTitle: "Room's name", secondTitle: room.name)
        view.addSubview(nameTitle)
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTitle.setSideConstraints(self, constant: 20)
        nameTitle.setTopConstraint(self, constant: 10)
        nameTitle.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configureWaitLabel() {
        waitLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        waitLabel.numberOfLines = 0
        waitLabel.text = "Wait till creator send you your card"
        waitLabel.textAlignment = .center
        waitLabel.textColor = Colors.secondaryInterface
        view.addSubview(waitLabel)
        waitLabel.translatesAutoresizingMaskIntoConstraints = false
        waitLabel.setSideConstraints(self, constant: 20)
        waitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waitLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setBottomConstraint(self, constant: -20)
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        dismissButton.setPrimaryStyle(icon: Icons.cross, color: Colors.red)
        dismissButton.addTarget(self, action: #selector(dismissButtonAction), for: .touchDown)
    }
    
    private func removeUserFromRoom(_ user: User, _ room: Room) {
        let userReference = Database.database().reference().child("rooms").child(room.token).child("users").child(user.token)
        userReference.removeValue()
    }
    
    @objc func dismissButtonAction() {
        guard let user = UserManager.shared.user else { return }
        removeUserFromRoom(user, room)
        delegate?.cardViewController(self, didDismiss: room)
    }
}

//MARK: - card
extension CardViewController {
    private func showCard(_ role: Role) {
        UIView.animate(withDuration: 0.3, animations: {
            [unowned self] in
            nameTitle.alpha = 0
            dismissButton.alpha = 0
            waitLabel.alpha = 0
        }, completion: {
            [unowned self] _ in
            setCardState(role)
        })
    }
    
    private func setCardState(_ role: Role) {
        let card = CardView(role: role)
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.setSideConstraints(self, constant: 20)
        card.setTopConstraint(self, constant: 20)
        
        card.alpha = 0
        
        let confirmButton = UIButton()
        
        view.addSubview(confirmButton)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 20).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.setBottomConstraint(self, constant: -20)
        confirmButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        confirmButton.setPrimaryStyle(icon: Icons.tick, color: Colors.primary)
        confirmButton.alpha = 0
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchDown)
        
        UIView.animate(withDuration: 0.3, animations: {
            card.alpha = 1
            confirmButton.alpha = 1
        })
    }
    
    @objc func confirmButtonAction() {
        delegate?.cardViewController(self, didEndedWith: room, role: role)
    }
}
