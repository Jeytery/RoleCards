//
//  MixerViewController.swift
//  RoleCards
//
//  Created by Jeytery on 03.03.2022.
//

import UIKit

protocol RoleCountTableCellDelegate: AnyObject {
    func roleCountTableCell(
        _ cell: RoleCountTableCell,
        didChange count: Int,
        of role: Role,
        for indexPath: IndexPath
    )
}

class RoleCountTableCell: TableCell<RoleCountView>, RoleCountViewDelegate {
    var delegate: RoleCountTableCellDelegate?
    var indexPath: IndexPath!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func roleCountView(_ view: RoleCountView, didChange count: Int, of role: Role) {
        delegate?.roleCountTableCell(self, didChange: count, of: role, for: indexPath)
    }
}

class MixerViewController: UIViewController {
    
    private let tableView = StateTableView(title: "No roles...")
    private let mixerBarView = MixerBarView()
    
    private let cellHeight: CGFloat = 100
    
    private var playersCount: Int { return roleCounts.reduce(0, +) }
    
    private var allRoles: Roles {
        var allRoles: Roles = []
        for index in 0 ..< roles.count {
            let arr = repeatElement(roles[index], count: roleCounts[index])
            allRoles += arr
        }
        return allRoles
    }
    
    //state
    private var roles: Roles = []
    private var roleCounts: [Int] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
        configureTableView()
        configureMixerBarView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

//MARK: - ui
extension MixerViewController {
    private func configureMixerBarView() {
        mixerBarView.delegate = self
        
        view.addSubview(mixerBarView)
        mixerBarView.translatesAutoresizingMaskIntoConstraints = false
        mixerBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mixerBarView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        mixerBarView.setBottomConstraint(self, constant: -20)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setTopConstraint(self)
        tableView.setBottomConstraint(self)
        tableView.setSideConstraints(self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RoleCountTableCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = .init(
            top: 0,
            left: 0,
            bottom: mixerBarView.frame.height,
            right: 0
        )
    }
    
    private func configureUI() {
        view.backgroundColor = tableView.backgroundColor
        title = "Player 0"
    }
    
    private func showEmptyAlert() {
        let alert = UIAlertController(title: "No roles picked!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    private func setPlayerCount(_ count: Int) {
        title = "Player " + String(playersCount)
        tabBarController?.tabBar.items?[0].title = ""
    }
}

//MARK: - [d] tableView
extension MixerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return roles.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! RoleCountTableCell
        
        let role = roles[indexPath.row]
        cell.baseView.setRole(role)
        cell.delegate = self
        cell.indexPath = indexPath
        cell.baseView.setCount(roleCounts[indexPath.row])
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle != .delete { return }
        roles.remove(at: indexPath.row)
        roleCounts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        setPlayerCount(playersCount)
    }
}

//MARK: - [d] mixerBar
extension MixerViewController: MixerBarViewDelegate {
    func mixerBarView(_ mixerBar: MixerBarView, didTapTrash view: UIView) {
        roles.removeAll()
        roleCounts.removeAll()
        tableView.reloadData()
        setPlayerCount(0)
    }
    
    func mixerBarView(_ mixerBar: MixerBarView, didTapAddCard view: UIView) {
        let roleVC = RoleViewController()
        let baseNC = BaseNavigationController(rootViewController: roleVC, withBigTitle: false)
        roleVC.delegate = self
        present(baseNC, animated: true, completion: nil)
    }
    
    func mixerBarView(_ mixerBar: MixerBarView, didTapAddDeck view: UIView) {
        let decksVC = DecksViewController()
        let nvc = BaseNavigationController(rootViewController: decksVC)
        decksVC.delegate = self
        present(nvc, animated: true, completion: nil)
    }
    
    func mixerBarView(_ mixerBar: MixerBarView, didTapShuffle view: UIView) {
        if playersCount == 0 { return showEmptyAlert() }
        let cardStackVC = CardsStackViewController(roles: allRoles.shuffled())
        let nvc = BaseNavigationController(rootViewController: cardStackVC)
        present(nvc, animated: true, completion: nil)
    }
}

//MARK: - [d] roleVC
extension MixerViewController: RoleViewControllerDelegate {
    func roleViewController(_ viewController: RoleViewController, didTapConfirmButtonWith role: Role) {
        viewController.dismiss(animated: true, completion: nil)
        roles.append(role)
        roleCounts.append(0)
        tableView.reloadData()
    }
}

//MARK: - [d] decksVC
extension MixerViewController: DecksViewControllerDelegate {
    func decksViewController(_ viewController: DecksViewController, didChoose deck: Deck) {
        viewController.dismiss(animated: true, completion: nil)
        roles.append(contentsOf: deck.roles)
        roleCounts.append(contentsOf: repeatElement(0, count: deck.roles.count))
        tableView.reloadData()
    }
}

//MARK: - [d] roleCountView
extension MixerViewController: RoleCountTableCellDelegate {
    func roleCountTableCell(
        _ cell: RoleCountTableCell,
        didChange count: Int,
        of role: Role,
        for indexPath: IndexPath
    ) {
        roleCounts[indexPath.row] = count
        setPlayerCount(playersCount)
    }
}

