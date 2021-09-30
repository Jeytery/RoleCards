//
//  MultiplayerViewController.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit
import FirebaseDatabase

class MultiplayerViewController: UIViewController {
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        configureButton()
    }
}

//MARK: - internal functions
extension MultiplayerViewController {
    private func configureButton() {
        let button = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.setTitle("add", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonAction), for: .touchDown)
    }
    
    @objc func buttonAction() {
        let user = User(username: "vanya", password: "12345", token: UUID().uuidString)
        database.child("users").childByAutoId().setValue(user.dictionary)
    }
}

//MARK: - public

