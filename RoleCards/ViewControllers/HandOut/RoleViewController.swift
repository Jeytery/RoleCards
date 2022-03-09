//
//  RoleViewController.swift
//  RoleCards
//
//  Created by Jeytery on 04.10.2021.
//

import UIKit
import Pikko

//class RoleViewController: UIViewController {
//
//    weak var delegate: RoleViewControllerDelegate?
//
//    private let list = StackListView(axis: .vertical)
//    private var nameTextField: DescTextFieldView!
//    private var descTextField: DescTextFieldView!
//    private let colorView = UIView()
//
//    private var listBottomConstraint: NSLayoutConstraint!
//    private var role: Role
//
//    init(role: Role = Role(name: "", color: Colors.red.roleColor, description: "")) {
//        self.role = role
//        super.init(nibName: nil, bundle: nil)
//        configureUI()
//        configureList()
//        configureButtons()
//        fetchData(role)
//
//        configureKeyboardNotification()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        view.endEditing(true)
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//}
//
////MARK: - internal functions
//extension RoleViewController {
//    private func configureKeyboardNotification() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardDidHide),
//            name: UIResponder.keyboardDidHideNotification,
//            object: nil
//        )
//    }
//
//    private func checkReadness() -> Bool {
//        if nameTextField.text == "" {
//            nameTextField.setError(text: "Put role name, please")
//            return false
//        }
//        return true
//    }
//
//    private func fetchData(_ role: Role) {
//        nameTextField.text = role.name
//        descTextField.text = role.description
//        colorView.backgroundColor = role.color.uiColor
//    }
//}
//
////MARK: - ui
//extension RoleViewController {
//    @objc func keyboardWillShow(_ notification: Notification) {
//        var constant = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
//        constant *= -1
//        listBottomConstraint.constant = constant
//        list.updateConstraints()
//    }
//
//    @objc func keyboardDidHide(_ notification: Notification) {
//        listBottomConstraint.constant = 0
//        list.updateConstraints()
//    }
//
//    private func configureUI() {
//        view.backgroundColor = Colors.background
//        title = "Role"
//    }
//
//    private func configureList() {
//        view.addSubview(list)
//        list.translatesAutoresizingMaskIntoConstraints = false
//        list.stackView.spacing = 10
//        list.setTopConstraint(self, constant: 20)
//        listBottomConstraint = list.getBottomConstraint(self)
//        list.setSideConstraints(self, constant: 20)
//
//        //name
//        nameTextField = DescTextFieldView(title: "Role's name",
//                                          placeholder: "For example: Mafia")
//        list.addView(nameTextField, size: 100)
//
//        //description
//        descTextField = DescTextFieldView(title: "Description",
//                                          placeholder: "For example: Mafia can shot at night")
//        list.addView(descTextField, size: 100)
//
//        //colorView
//        let colorTitle = UILabel()
//        colorTitle.text = "Color (Tap to choose)"
//        colorTitle.font = .systemFont(ofSize: 18, weight: .semibold)
//        list.addView(colorTitle, size: 20)
//
//        colorView.layer.cornerRadius = 10
//        colorView.backgroundColor = role.color.uiColor
//        colorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorViewAction)))
//        list.addView(colorView, size: 60)
//    }
//
//    @objc func colorViewAction() {
//        let colorVC = ColorPickerViewController()
//        colorVC.didChooseColor = {
//            [unowned self] color in
//            role.color = color.roleColor
//            colorView.backgroundColor = role.color.uiColor
//        }
//        navigationController?.pushViewController(colorVC, animated: true)
//    }
//
//    private func configureButtons() {
//        let stackView = UIStackView()
//        view.addSubview(stackView)
//        stackView.axis = .horizontal
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
//
//        let confirmButton = UIButton()
//        confirmButton.setPrimaryStyle(icon: Icons.tick, color: Colors.primary)
//        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchDown)
//
//        stackView.addArrangedSubview(confirmButton)
//        list.addView(stackView, size: 60)
//    }
//
//    @objc func confirmButtonAction() {
//        guard checkReadness() else { return }
//        role.name = nameTextField.text
//        role.description = descTextField.text
//        dismiss(animated: true, completion: nil)
//        delegate?.roleViewController(didReturn: role)
//    }
//}

protocol RoleViewControllerDelegate: AnyObject {
    func roleViewController(_ viewController: RoleViewController, didTapConfirmButtonWith role: Role)
}

class RoleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: RoleViewControllerDelegate?

    private var role: Role
    
    private let tableView = StateTableView(title: "")

    private let nameTextField = InsestsTextField(insests: .init(top: 0, left: 20, bottom: 0, right: 0))
    private let confirmButton = UIButton()
    private let colorView = UIView()
    
    struct Content {
        let sectionTitle: String
        let view: UIView
        let cellHeight: CGFloat
    }
    
    private lazy var contents: [Content] = [
        .init(sectionTitle: "Role name", view: nameTextField, cellHeight: 80),
        .init(sectionTitle: "Role color", view: colorView, cellHeight: 80),
        .init(sectionTitle: "", view: confirmButton, cellHeight: 50)
    ]
    
    init(role: Role = Role(name: "", color: Colors.red.roleColor, description: "")) {
        self.role = role
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        configureKeyboardNotification()
        
        configureTableView()
        
        configureNameTextField()
        configureColorView()
        configureConfirmButton()
        
        fetchData(role)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RoleViewController {
    private func configureColorView() {
        colorView.backgroundColor = Colors.red
        colorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorViewAction)))
    }
    
    private func configureNameTextField() {
        nameTextField.placeholder = "For example: Mafia"
        nameTextField.setStandartStyle()
        nameTextField.backgroundColor = .clear
    }
    
    private func configureConfirmButton() {
        confirmButton.setPrimaryStyle(icon: Icons.tick, color: Colors.blue)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setTopConstraint(self)
        tableView.setSideConstraints(self)
        tableView.setBottomConstraint(self)
        tableView.allowsSelection = false

        tableView.delegate = self
        tableView.dataSource = self

        for i in 0 ..< contents.count {
            tableView.register(TableCell<UIView>.self, forCellReuseIdentifier: "cell" + String(i))
        }
    }
}

//MARK: - internal functions
extension RoleViewController {
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }

    private func fetchData(_ role: Role) {
        nameTextField.text = role.name
        colorView.backgroundColor = role.color.uiColor
    }
}

extension RoleViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        let constant = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: constant, right: 0)
    }

    @objc func keyboardDidHide(_ notification: Notification) {
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
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
}

//MARK: - ui
extension RoleViewController {
    private func configureUI() {
        view.backgroundColor = tableView.backgroundColor
        title = "Role"
    }

    private func configureButtons() {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        confirmButton.setPrimaryStyle(icon: Icons.tick, color: Colors.primary)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchDown)

        stackView.addArrangedSubview(confirmButton)
    }

    @objc func confirmButtonAction() {
        role.name = nameTextField.text! == "" ? "Unnamed role" : nameTextField.text!
        role.description = ""
        delegate?.roleViewController(self, didTapConfirmButtonWith: role)
    }
}

extension RoleViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return contents[section].sectionTitle
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let view = contents[indexPath.section].view
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell" + String(indexPath.section),
            for: indexPath
        ) as! TableCell<UIView>
        
        cell.setView(view)
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return contents[indexPath.section].cellHeight
    }
}
