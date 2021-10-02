//
//  AutorizationViewController.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit
import FirebaseDatabase

protocol AutorizationViewControllerDelegate: AnyObject {
    func autorizationViewControllerDidAutorized()
}

class AutorizationViewContoller: UIViewController {
    
    weak var delegate: AutorizationViewControllerDelegate?

    private let database = Database.database().reference()
    
    private let nameTextField = DescTextFieldView(title: "Name", placeholder: "For Example: Jeytery")
    private let passwordTextField = DescTextFieldView(title: "Password", placeholder: "No 12345, please")
    private let nextButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        configureUI()
        configureNextButton()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - ui
extension AutorizationViewContoller {
    private func configureUI() {
        title = "Autorization"
        setLargeTitle()
        
        let list = StackListView(axis: .vertical)
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        list.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        list.addView(nameTextField, size: 90)
        list.addView(passwordTextField, size: 90)
    }
    
    private func configureNextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.setStandartStyle()
        nextButton.setTitle("Sign in", for: .normal)
        nextButton.backgroundColor = .red
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchDown)
    }
    
    private func setErrors() {
        DispatchQueue.main.async {
            [unowned self] in 
            if nameTextField.text == "" {
                nameTextField.textField.setErrorState()
            }
            
            if passwordTextField.text == "" {
                passwordTextField.textField.setErrorState()
            }
        }
    }
}

//MARK: - autorization
extension AutorizationViewContoller {
    private func addUser(_ user: User) {
        database.child("users").childByAutoId().setValue(user.dictionary)
    }
    
    private func addUser(username: String, password: String, token: String) {
        DispatchQueue.main.async {
            [weak self] in
            let user = User(username: username,
            password: password,
            token: token)
            self?.addUser(user)
        }
    }
    
    private func checkTextFieldReadness() -> Bool {
        setErrors()
        if nameTextField.text != "" || passwordTextField.text != "" { return false }
        return true
    }
    
    private func setNickExistingError() {
        DispatchQueue.main.async {
            [nameTextField] in
            nameTextField.setError(text: "This username is taken. Try another")
        }
    }
    
    private func findUserByName(username: String, users: Users) -> User? {
        for user in users {
            if username == user.username { return user }
        }
        return nil
    }
 
    private func checkAccountPassword(_ password: String) {
        DispatchQueue.main.async {
            [unowned self] in
            if password == passwordTextField.text {
                print("Success!")
                delegate?.autorizationViewControllerDidAutorized()
            }
            else {
                passwordTextField.setError(text: "Password for this use is incorrect, try again")
            }
        }
    }
    
    @objc func nextButtonAction() {
        if checkTextFieldReadness() { return }
        nextButton.isEnabled = false
        let username = nameTextField.text
        let password = passwordTextField.text
        getUsers(completion: {
            [unowned self] result in
            DispatchQueue.main.async { nextButton.isEnabled = true }
            switch result {
            case .success(let users):
                guard let user = findUserByName(username: username, users: users) else {
                    addUser(username: username,
                            password: password,
                            token: UUID().uuidString)
                    return
                }
                checkAccountPassword(user.password)
                break
            case .failure(let error):
                print(error);
                break
            }
        })
    }
}
