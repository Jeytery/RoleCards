//
//  RoleViewController.swift
//  RoleCards
//
//  Created by Jeytery on 04.10.2021.
//

import UIKit
import Pikko

protocol RoleViewControllerDelegate: AnyObject {
    func roleViewControllerShouldIconForRedButton() -> UIImage
    func roleViewControllerRedButtonDidTap()
    func roleViewController(didReturn role: Role)
}

extension RoleViewControllerDelegate {
    func roleViewControllerShouldIconForRedButton() -> UIImage { return Icons.exit }
    func roleViewControllerRedButtonDidTap() {}
}

class RoleViewController: UIViewController {
    
    weak var delegate: RoleViewControllerDelegate?
    
    private let list = StackListView(axis: .vertical)
    private var nameTextField: DescTextFieldView!
    private var descTextField: DescTextFieldView!
    private let colorView = UIView()
    
    private var listBottomConstraint: NSLayoutConstraint!
    private var role: Role
    
    init(role: Role = Role(name: "", color: Colors.red.roleColor, description: "")) {
        self.role = role
        super.init(nibName: nil, bundle: nil)
        configureUI()
        configureList()
        configureButtons()
        fetchData(role)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - internal functions
extension RoleViewController {
    private func checkReadness() -> Bool {
        if nameTextField.text == "" {
            nameTextField.setError(text: "Put role name, please")
            return false
        }
        return true
    }
    
    private func fetchData(_ role: Role) {
        nameTextField.text = role.name
        descTextField.text = role.description
        colorView.backgroundColor = role.color.uiColor
    }
}

//MARK: - ui
extension RoleViewController {
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
    
    private func configureUI() {
        view.backgroundColor = Colors.background
        title = "Role"
    }
    
    private func configureList() {
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.stackView.spacing = 10
        list.setTopConstraint(self, constant: 20)
        listBottomConstraint = list.getBottomConstraint(self)
        list.setSideConstraints(self, constant: 20)
        
        //name
        nameTextField = DescTextFieldView(title: "Role's name",
                                          placeholder: "For example: Mafia")
        list.addView(nameTextField, size: 100)
        
        //description
        descTextField = DescTextFieldView(title: "Description",
                                          placeholder: "For example: Mafia can shot at night")
        list.addView(descTextField, size: 100)
    
        //colorView
        let colorTitle = UILabel()
        colorTitle.text = "Color (Tap to choose)"
        colorTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        list.addView(colorTitle, size: 20)
        
        colorView.layer.cornerRadius = 10
        colorView.backgroundColor = role.color.uiColor
        colorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorViewAction)))
        list.addView(colorView, size: 60)
    }
    
    @objc func colorViewAction() {
        let colorVC = ColorPickerViewController()
        colorVC.didChooseColor = {
            [unowned self] color in
            role.color = color.roleColor
            colorView.backgroundColor = role.color.uiColor
        }
        navigationController?.pushViewController(colorVC, animated: true)
    }
    
    private func configureButtons() {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        let confirmButton = UIButton()
        confirmButton.setPrimaryStyle(icon: Icons.tick, color: Colors.primary)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchDown)
        
        stackView.addArrangedSubview(confirmButton)
        list.addView(stackView, size: 60)
    }
    
    @objc func confirmButtonAction() {
        guard checkReadness() else { return }
        role.name = nameTextField.text
        role.description = descTextField.text
        dismiss(animated: true, completion: nil)
        delegate?.roleViewController(didReturn: role)
    }
}
