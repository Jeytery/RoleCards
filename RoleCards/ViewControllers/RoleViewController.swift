//
//  RoleViewController.swift
//  RoleCards
//
//  Created by Jeytery on 04.10.2021.
//

import UIKit

protocol RoleViewControllerDelegate: AnyObject {
    func roleViewControllerShouldIconForRedButton() -> UIImage
    func roleViewControllerRedButtonDidTap()
    func roleViewController(didReturn role: Role)
}

class RoleViewController: UIViewController {
    
    weak var delegate: RoleViewControllerDelegate?
    
    private let list = StackListView(axis: .vertical)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
        configureList()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ui
extension RoleViewController {
    private func configureUI() {
        view.backgroundColor = Colors.background
        title = "Role"
    }
    
    private func configureList() {
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.setTopConstraint(self)
        list.setSideConstraints(self, constant: 20)
        
        let nameTextField = DescTextFieldView(title: "Role's name",
                                              placeholder: "For example: Mafia")
        list.addView(nameTextField, size: 100)
        
        let descTextField = DescTextFieldView(title: "Description",
                                              placeholder: "For example: Mafia can shot at night")
        list.addView(descTextField, size: 150)
    }
    
    private func configureButtons() {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setBottomConstraint(self, constant: -25)
        stackView.topAnchor.constraint(equalTo: list.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        let confirmButton = UIButton()
        let dissmisButton = UIButton()
        confirmButton.setPrimaryStyle(icon: Icons.tick, color: Colors.primary)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchDown)
        dissmisButton.setPrimaryStyle(icon: Icons.exit, color: Colors.red)
        dissmisButton.addTarget(self, action: #selector(dissmisButtonAction), for: .touchDown)
        
        stackView.addArrangedSubview(confirmButton)
        stackView.addArrangedSubview(dissmisButton)
    }
    
    @objc func confirmButtonAction() {
        print("confirmButtonAction")
    }
    @objc func dissmisButtonAction() {
        print("dissmisButtonAction")
        dismiss(animated: true, completion: nil)
        delegate?.roleViewControllerRedButtonDidTap()
    }
}

