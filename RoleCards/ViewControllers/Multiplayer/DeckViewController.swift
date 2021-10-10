//
//  DeckViewController.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit

protocol DeckViewControllerDelegate: AnyObject {
    func deckViewController(_ viewController: UIViewController, didChoose roles: Roles)
}

class DeckViewController: UIViewController {
    
    weak var delegate: DeckViewControllerDelegate?
    
    private let list = StateCollectionView()
    
    private var standartRole: Role!
    private var currentIndex: Int = 0
    
    private var roles: Roles = [] {
        didSet { list.reloadData() }
    }
    
    init(playersCount: Int) {
        super.init(nibName: nil, bundle: nil)
        standartRole = getStandartRole()
        roles = getRolesArray(playersCount: playersCount, role: standartRole)
        conifgureList()
        configureUI()
        configureNextButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - internal functions
extension DeckViewController {
    private func getStandartRole() -> Role {
        if let role = RolesViewModel.getFirstRole() { return role }
        return Role(name: "?", color: Colors.red.roleColor, description: "???")
    }
    
    private func getRolesArray(playersCount: Int, role: Role) -> Roles {
        var arr: Roles = []
        for _ in 0..<playersCount { arr.append(role) }
        return arr
    }
}

//MARK: - ui
extension DeckViewController {
    private func configureUI() {
        view.backgroundColor = Colors.background
        title = "Roles"
    }
    
    private func conifgureList() {
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false 
        list.delegate = self
        list.dataSource = self
        list.setFullScreenConstraints(self)
        list.register(SmallRoleCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func configureNextButton() {
        let nextButton = UIButton()
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.setBottomConstraint(self, constant: -20)
        nextButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        nextButton.setPrimaryStyle(icon: Icons.vector, color: Colors.primary)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchDown)
    }
    
    @objc func nextButtonAction() {
        delegate?.deckViewController(self, didChoose: roles)
    }
}

//MARK: - [d] List
extension DeckViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
                                                      for: indexPath) as! SmallRoleCell
        cell.setRole(roles[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenWidth = UIScreen.main.bounds.width
        let size = (screenWidth - 10 - 10) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 5, bottom: view.bottomIndentValue + 70 + 5, right: 5)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath)
    {
        currentIndex = indexPath.row
        let rolesVC = RolesViewController()
        rolesVC.delegate = self
        let nvc = BaseNavigationController(rootViewController: rolesVC)
        present(nvc, animated: true, completion: nil)
    }
}

//MARK: - [d] roleVC
extension DeckViewController: RolesViewControllerDelegate {
    func rolesViewController(didSelect: Role) {
        roles.remove(at: currentIndex)
        roles.insert(didSelect, at: currentIndex)
    }
}

fileprivate class SmallRoleCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        layer.cornerRadius = DesignProperties.cornerRadius
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRole(_ role: Role) {
        backgroundColor = role.color.uiColor
        titleLabel.textColor = Luma.blackOrWhite(role.color.uiColor)
        titleLabel.text = String(role.name[role.name.startIndex])
    }
}
