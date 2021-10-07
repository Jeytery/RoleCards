//
//  DeckInfoViewController.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit

protocol DeckInfoViewControllerDelegate: AnyObject {
    func deckInfoViewController(_ viewController: UIViewController, didDismissWith name: String, password: String)
}

class DeckInfoViewController: UIViewController {
    
    weak var delegate: DeckInfoViewControllerDelegate?
    
    private let list = StackListView(axis: .vertical)
    private let nameTextField = DescTextFieldView(title: "Enter room name", placeholder: "For example: My Room")
    private let passwordTextField = DescTextFieldView(title: "Enter password", placeholder: "Optional, but recommended")
    private let nextButton = UIButton()
    private var listBottomConstraint: NSLayoutConstraint!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureList()
        view.backgroundColor = Colors.background
        title = "Room info"
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ui
extension DeckInfoViewController {
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
    
    private func configureList() {
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        listBottomConstraint = list.getBottomConstraint(self)
        list.setTopConstraint(self, constant: 20)
        list.setSideConstraints(self, constant: 20)
        
        list.addView(nameTextField, size: 100)
        list.addView(passwordTextField, size: 100)
        list.addView(nextButton, size: 50)
        
        nextButton.setPrimaryStyle(icon: Icons.tick, color: Colors.primary)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchDown)
    }
    
    @objc func nextButtonAction() {
        delegate?.deckInfoViewController(self, didDismissWith: nameTextField.text, password: passwordTextField.text)
    }
}
