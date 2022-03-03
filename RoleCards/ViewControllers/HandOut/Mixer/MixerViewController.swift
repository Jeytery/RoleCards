//
//  MixerViewController.swift
//  RoleCards
//
//  Created by Jeytery on 03.03.2022.
//

import UIKit

class MixerViewController: UIViewController {
    
    private let tableView = StateTableView(title: "No roles...")
    
    private var roles: Roles = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = tableView.backgroundColor
        title = "Player 0"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setTopConstraint(self)
        tableView.setBottomConstraint(self)
        tableView.setSideConstraints(self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TableCell<RoleCountView>.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        
        // mixer bar
        
        let mixerBarView = MixerBarView()
        mixerBarView.delegate = self
        
        view.addSubview(mixerBarView)
        mixerBarView.translatesAutoresizingMaskIntoConstraints = false
        mixerBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mixerBarView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        mixerBarView.setBottomConstraint(self, constant: -20)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension MixerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell<RoleCountView>
        let role = roles[indexPath.row]
        cell.baseView.setRole(role)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle != .delete { return }
        roles.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension MixerViewController: MixerBarViewDelegate {
    func mixerBarView(_ mixerBar: MixerBarView, didTapTrash view: UIView) {
        roles.removeAll()
        tableView.reloadData()
    }
    
    func mixerBarView(_ mixerBar: MixerBarView, didTapAddCard view: UIView) {
        let roleVC = RoleViewController()
        let baseNC = BaseNavigationController(rootViewController: roleVC)
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
        let cardStackVC = CardsStackViewController(roles: roles.shuffled())
        let nvc = BaseNavigationController(rootViewController: cardStackVC)
        present(nvc, animated: true, completion: nil)
    }
}

extension MixerViewController: RoleViewControllerDelegate {
    func roleViewController(didReturn role: Role) {
        roles.append(role)
        tableView.reloadData()
    }
}

extension MixerViewController: DecksViewControllerDelegate {
    func decksViewController(_ viewController: DecksViewController, didChoose deck: Deck) {
        viewController.dismiss(animated: true, completion: nil)
        roles.append(contentsOf: deck.roles)
        tableView.reloadData()
    }
}

fileprivate class RoleCountView: UIView {
    
    private let stepper = Stepper(style: .dark)
    private let circleRoleView = CircleRoleView()
    private let roleNameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        stepper.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stepper.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stepper.widthAnchor.constraint(equalToConstant: 120).isActive = true
        stepper.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        addSubview(circleRoleView)
        circleRoleView.translatesAutoresizingMaskIntoConstraints = false
        circleRoleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circleRoleView.heightAnchor.constraint(equalToConstant: 39).isActive = true
        circleRoleView.widthAnchor.constraint(equalToConstant: 39).isActive = true
        circleRoleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        roleNameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(roleNameLabel)
        roleNameLabel.translatesAutoresizingMaskIntoConstraints = false
        roleNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        roleNameLabel.leftAnchor.constraint(equalTo: circleRoleView.rightAnchor, constant: 15).isActive = true
        roleNameLabel.rightAnchor.constraint(equalTo: stepper.leftAnchor, constant: -15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setRole(_ role: Role) {
        circleRoleView.setRole(role)
        roleNameLabel.text = role.name
    }
}
