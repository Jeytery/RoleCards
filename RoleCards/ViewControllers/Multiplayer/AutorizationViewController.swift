//
//  AutorizationViewController.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit
import FirebaseDatabase

protocol AutorizationViewControllerDelegate: AnyObject {
    func autorizationViewController(_ viewController: UIViewController, didAutorized user: User)
}

class AutorizationViewContoller: UIViewController {
    
    weak var delegate: AutorizationViewControllerDelegate?
    
    var isTextFieldsReady: Bool {
        setErrors()
        if nameTextField.text == "" || passwordTextField.text == "" { return false }
        return true
    }

    private let database = Database.database().reference()
    
    private let nameTextField = DescTextFieldView(title: "Name", placeholder: "For Example: Jeytery")
    private let passwordTextField = DescTextFieldView(title: "Password", placeholder: "No 12345, please")
    private let nextButton = UIButton()
    private let list = StackListView(axis: .vertical)
    private var listBottomConstraint: NSLayoutConstraint!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Colors.background
        configureUI()
        configureNextButton()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - ui
extension AutorizationViewContoller {
    @objc func keyboardWillShow(_ notification: Notification) {
        var constant = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        constant *= -1
        listBottomConstraint.constant = constant
        list.updateConstraints()
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        listBottomConstraint.constant = 0
        list.updateConstraints()
    }
    
    @objc func closeKeyboardAction() {
        view.endEditing(true)
    }
    
    private func configureUI() {
        title = "Autorization"
        
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        listBottomConstraint = list.getBottomConstraint(self)
        listBottomConstraint.isActive = true
        list.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        list.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        list.addView(nameTextField, size: 110)
        list.addView(passwordTextField, size: 110)
        
        list.stackView.spacing = 20

        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(closeKeyboardAction)))
    }
    
    private func configureNextButton() {
        let nbView = UIView()
        nbView.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.bottomAnchor.constraint(equalTo: nbView.bottomAnchor, constant: -20).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: nbView.centerXAnchor).isActive = true
        
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchDown)
        nextButton.setPrimaryStyle(icon: Icons.vector, color: Colors.primary)
        list.addView(nbView, size: 100)
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
    private func addUserToDatabase(_ user: User) {
        DispatchQueue.main.async {
            addUser(user)
        }
    }

    private func setNickExistingError() {
        DispatchQueue.main.async {
            [nameTextField] in
            nameTextField.setError(text: "This username is taken. Try another")
        }
    }

    private func checkAccountPassword(_ user: User) {
        DispatchQueue.main.async {
            [unowned self] in
            if user.password == passwordTextField.text {
                print("Success!")
                if UserManager.shared.getUser() == nil { UserManager.shared.saveUser(user) }
                delegate?.autorizationViewController(self, didAutorized: user)
            }
            else {
                passwordTextField.setError(text: "Password for this use is incorrect, try again")
            }
        }
    }
    
    @objc func nextButtonAction() {
        guard isTextFieldsReady else { return }
        nextButton.isEnabled = false
        let username = nameTextField.text
        let password = passwordTextField.text

        findUser(username: username, completion: {
            [unowned self] result in
            DispatchQueue.main.async { nextButton.isEnabled = true }
            switch result {
            case .success(let user):
                checkAccountPassword(user)
                break
            case .failure(let error):
                print("findUserByUsername: \(error)")
                let user = User(username: username, password: password, token: UUID().uuidString)
                addUserToDatabase(user)
                delegate?.autorizationViewController(self, didAutorized: user)
                break
            }
        })
    }
}
