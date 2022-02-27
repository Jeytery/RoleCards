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
    
    enum RoleActionType {
        case edit
        case add
    }
    
    weak var delegate: RolesViewControllerDelegate?
    
    private let viewModel = RolesViewModel()
    private var roleActionType: RoleActionType = .add
    private var isListEditing = false
    private var currentEditingCell: Int = 0
    
    private let list = StateCollectionView(title: "No roles...")
    private let addRoleButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureList()
        configureAddRoleButton()
        configureUI()
        
        viewModel.rolesObservable.subscribe(onUpdate: {
            [unowned self] roles in
            list.reloadData()
        })
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        setCellEdit(isEditing: editing)
    }
}

//MARK: - ui
extension RolesViewController {
    @objc func crossButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    private func configureUI() {
        title = "Roles"
        view.backgroundColor = Colors.background
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func configureList() {
        view.addSubview(list)
        list.delegate = self
        list.dataSource = self
        list.translatesAutoresizingMaskIntoConstraints = false
        
        list.setTopConstraint(self)
        list.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        list.register(RoleCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func configureAddRoleButton() {
        view.addSubview(addRoleButton)
        addRoleButton.translatesAutoresizingMaskIntoConstraints = false
        addRoleButton.setBottomConstraint(self, constant: -10)
        addRoleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addRoleButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addRoleButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addRoleButton.addTarget(self, action: #selector(addRoleButtonAction), for: .touchDown)
        addRoleButton.setPrimaryStyle(icon: Icons.plus, color: Colors.primary)
    }
}

//MARK: - internal funcs
extension RolesViewController {
    @objc func addRoleButtonAction() {
        setEditing(false, animated: false)
        showRoleVC()
    }
    
    private func setCellEdit(isEditing: Bool) {
        isListEditing = isEditing
        roleActionType = isEditing ? .edit : .add
        for i in 0..<viewModel.roles.count {
            guard let cell = list.cellForItem(at: IndexPath(row: i, section: 0)) as? RoleCell else { return }
            cell.roleView.isEditing = isEditing
        }
    }
    
    private func showRoleVC(role: Role = Role(
        name: "",
        color: Colors.red.roleColor,
        description: ""))
    {
        let roleVC = RoleViewController(role: role)
        roleVC.delegate = self
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
        return viewModel.roles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! RoleCell
        cell.delegate = self
        let role = viewModel.roles[indexPath.row]
        cell.roleView.isEditing = isListEditing
        cell.setRole(role)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 20, left: 20, bottom: 100, right: 20)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath)
    {
        let role = viewModel.roles[indexPath.row]
        delegate?.rolesViewController(didSelect: role)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - [d] roleVC
extension RolesViewController: RoleViewControllerDelegate {
    func roleViewController(didReturn role: Role) {
        if roleActionType == .add {
            viewModel.saveRole(role)
        }
        else if roleActionType == .edit {
            viewModel.updateRole(role, at: currentEditingCell)
        }
    }
}

//MARK: - [d] roleCell
extension RolesViewController: RoleCellDelegate {
    func roleCell(didTapEditWith view: UIView, cell: UICollectionViewCell) {
        guard let indexPath = list.indexPath(for: cell) else { return }
        currentEditingCell = indexPath.row
        showRoleVC(role: viewModel.roles[indexPath.row])
    }
    
    func roleCell(didTapDeleteWith view: UIView, cell: UICollectionViewCell) {
        guard let indexPath = list.indexPath(for: cell) else { return }
        viewModel.deleteRole(at: indexPath.row)
    }
}

protocol RoleCellDelegate: AnyObject {
    func roleCell(didTapEditWith view: UIView, cell: UICollectionViewCell)
    func roleCell(didTapDeleteWith view: UIView, cell: UICollectionViewCell)
}

class RoleCell: UICollectionViewCell, RoleViewDelegate {
   
    weak var delegate: RoleCellDelegate?
    
    private(set) var roleView = RoleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(roleView)
        roleView.translatesAutoresizingMaskIntoConstraints = false
        roleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roleView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        roleView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        roleView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        roleView.delegate = self
    }
    
    func setRole(_ role: Role) {
        roleView.setRole(role)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func roleView(didTapDeleteWith view: UIView) {
        delegate?.roleCell(didTapDeleteWith: roleView, cell: self)
    }
    
    func roleView(didTapEdit view: UIView) {
        delegate?.roleCell(didTapEditWith: roleView, cell: self)
    }
}
