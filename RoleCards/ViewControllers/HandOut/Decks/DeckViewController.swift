//
//  _DeckViewController.swift
//  RoleCards
//
//  Created by Jeytery on 01.03.2022.
//

import UIKit

protocol DeckViewControllerDelegate: AnyObject {
    func deckViewController(_ viewController: UIViewController, didTapSaveButtonWith deck: Deck)
}

class DeckViewController: UIViewController {

    weak var delegate: DeckViewControllerDelegate?
    
    private let tableView = StateTableView(title: "No roles...")
    
    private let rowHeight: CGFloat = 100
    
    private let deck:  Deck
    private var roles: Roles
    
    private lazy var header = HeaderView()
    private lazy var footer = FooterView()
    
    private let saveButton = UIButton()
    private let nameTextField = InsestsTextField(insests: .init(top: 0, left: 20, bottom: 0, right: 0))
    
    init(deck: Deck) {
        self.deck = deck
        self.roles = deck.roles
        super.init(nibName: nil, bundle: nil)
        
        configureTableView()
        configureAddRoleButton()
        configureUI()
        handleKeyboardNotifications()
        configureSaveButton()
        configureNameTextField()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

//MARK: - @objc
extension DeckViewController {
    @objc func viewDidTap() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func saveButtonAction() {
        let deckName = nameTextField.text == "" ? "Unnamed deck" : nameTextField.text!
        let deck = Deck(name: deckName, roles: roles)
        delegate?.deckViewController(self, didTapSaveButtonWith: deck)
    }
    
    @objc func leftButtonAction() {
        let roleVC = RoleViewController()
        roleVC.delegate = self
        let nvc = BaseNavigationController(rootViewController: roleVC, withBigTitle: false)
        present(nvc, animated: true, completion: nil)
    }
}

//MARK: - ui configuration
extension DeckViewController {
    private func configureUI() {
        view.backgroundColor = tableView.backgroundColor
        title = "Deck"
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTap)))
        nameTextField.text = deck.name
    }
    
    private func configureNameTextField() {
        nameTextField.placeholder = "Deck name"
        nameTextField.font = .systemFont(ofSize: 18, weight: .semibold)

        nameTextField.layer.masksToBounds = true
        nameTextField.backgroundColor = Colors.background 
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = DesignProperties.cornerRadius
        nameTextField.layer.borderColor = Colors.background.cgColor
    }
    
    private func configureSaveButton() {
        saveButton.setPrimaryStyle(icon: Icons.tick, color: Colors.blue)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchDown)
    }
    
    private func handleKeyboardNotifications() {
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
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setTopConstraint(self)
        tableView.setBottomConstraint(self)
        tableView.setSideConstraints(self)
        
        tableView.register(TableCell<RoleView>.self, forCellReuseIdentifier: "cell")
        
        tableView.didReloadData = {
            [unowned self] in
            if roles.isEmpty {
                saveButton.isHidden = true
            }
            else {
                saveButton.isHidden = false
            }
        }
    }
    
    private func configureAddRoleButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add,
                                     target: self,
                                     action: #selector(leftButtonAction))
        navigationItem.rightBarButtonItem = button
    }
}

//MARK: - tableView logic
extension DeckViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return roles.count
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return rowHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! TableCell<RoleView>
        
        cell.baseView.setRole(roles[indexPath.row])
        cell.baseView.backgroundColor = .clear
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath)
    {
        if editingStyle != .delete { return }
        roles.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - tableView header/footer
extension DeckViewController {
    var headerHeight: CGFloat { return 100 }
    var footerHeight: CGFloat { return 70 }
    
    private func FooterView() -> UIView {
        let view = UIView()
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        return view
    }
    
    private func HeaderView() -> UIView {
        let view = UIView()
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        return view
    }
    
    // table view
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int) -> CGFloat
    {
        return headerHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int) -> CGFloat
    {
        return footerHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView?
    {
        return header
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int) -> UIView?
    {
        return footer
    }
}

//MARK: - [d] roleVC
extension DeckViewController: RoleViewControllerDelegate {
    func roleViewController(_ viewController: RoleViewController, didTapConfirmButtonWith role: Role) {
        viewController.dismiss(animated: true, completion: nil)
        roles.append(role)
        tableView.reloadData()
    }
}

