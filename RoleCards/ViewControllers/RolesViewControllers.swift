//
//  RolesViewControllers.swift
//  RoleCards
//
//  Created by Jeytery on 03.10.2021.
//

import UIKit

protocol RolesViewControllerDelegate: AnyObject {
    func rolesViewController(didSelect: Role)
}

class RolesViewController: UIViewController {
    
    weak var delegate: RolesViewControllerDelegate?
    
    private let roles: Roles
    
    private let list = StateCollectionView()
    private let addRoleButton = UIButton()
    
    init() {
        self.roles = RoleManager.shared.roles
        super.init(nibName: nil, bundle: nil)
        configureList()
        configureAddRoleButton()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: nil,
                                                            action: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - internal funcs
extension RolesViewController {
    private func configureUI() {
        title = "Roles"
        view.backgroundColor = Colors.background
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
//                                                            style: .plain,
//                                                            target: self,
//                                                            action: #selector(addTapped))
    }
        
    @objc func addTapped() {
        print("add")
    }
    
    private func configureList() {
        view.addSubview(list)
        
        list.delegate = self
        list.dataSource = self
        
        list.translatesAutoresizingMaskIntoConstraints = false
        list.setTopConstraint(self)
        list.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        list.registerView(RoleView.self)
    }
    
    private func configureAddRoleButton() {
        view.addSubview(addRoleButton)
        addRoleButton.translatesAutoresizingMaskIntoConstraints = false
        addRoleButton.setBottomConstraint(self, constant: -10)
        addRoleButton.topAnchor.constraint(equalTo: list.bottomAnchor).isActive = true
        addRoleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addRoleButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addRoleButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addRoleButton.addTarget(self, action: #selector(addRoleButtonAction), for: .touchDown)
        addRoleButton.setPrimaryStyle(icon: Icons.plus, color: Colors.primary)
    }
    
    @objc func addRoleButtonAction() {
        let roleVC = RoleViewController()
        let nvc = BaseNavigationController(rootViewController: roleVC)
        present(nvc, animated: true, completion: nil)
    }
}

//MARK: - [d] list
extension RolesViewController:
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource
{
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return roles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! BaseCell<RoleView>
        let v = cell.baseView as! RoleView
        v.setRole(roles[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
    }
}
