//
//  DecksViewController.swift
//  RoleCards
//
//  Created by Jeytery on 27.02.2022.
//

import UIKit

protocol DecksViewControllerDelegate: AnyObject {
    func decksViewController(_ viewController: DecksViewController, didChoose deck: Deck)
}

class DecksViewController: UIViewController {

    weak var delegate: DecksViewControllerDelegate?
    
    typealias Decks = [Deck]
    
    private let tableView = StateTableView(title: "No decks...")
    private let decksCenter = DataStorage<Deck>(id: .deck)
    
    private var currentIndex: Int = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
        configureList()
        configureAddButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension DecksViewController {
    private func configureUI() {
        view.backgroundColor = tableView.backgroundColor
        title = "Decks"
    }
    
    private func configureList() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerView(DeckView.self)
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.setBottomConstraint(self)
        tableView.setTopConstraint(self)
    }
    
    private func configureAddButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add,
                                     target: self,
                                     action: #selector(leftButtonAction))
        navigationItem.rightBarButtonItem = button
    }
    
    private func addEmptyDeck(title: String) {
        let deck = Deck(name: title, roles: [])
        decksCenter.saveElement(deck)
        tableView.reloadData()
    }
    
    @objc func leftButtonAction() {
        let alert = UIAlertController(title: "Enter deck name", message: nil, preferredStyle: .alert)

        alert.addTextField() {
            textField in
            textField.text = ""
            textField.placeholder = "For example: Mafia deck"
            textField.clearButtonMode = .whileEditing
        }

        let action = UIAlertAction(title: "OK", style: .default) {
            [weak self] _ in
            let textField = alert.textFields![0]
            guard textField.text != "" else { return }
            self?.addEmptyDeck(title: textField.text ?? "Unnamed deck")
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - [d] list
extension DecksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return decksCenter.data.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! TableCell<DeckView>
        
        cell.baseView.setDeck(decksCenter.data[indexPath.row])
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 100
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle != .delete { return }
        decksCenter.removeElement(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        if delegate != nil {
            delegate?.decksViewController(self, didChoose: decksCenter.data[indexPath.row])
            return
        }
        let deck = decksCenter.data[indexPath.row]
        currentIndex = indexPath.row
        
        let deckVC = _DeckViewController(deck: deck)
        deckVC.delegate = self
        
        let nvc = BaseNavigationController(rootViewController: deckVC,
                                           buttonSide: .left,
                                           withBigTitle: false)
        present(nvc, animated: true, completion: nil)
    }
}

//MARK: - [d] deckVC
extension DecksViewController: _DeckViewControllerDelegate {
    func deckViewController(_ viewController: UIViewController, didTapSaveButtonWith deck: Deck) {
        viewController.dismiss(animated: true, completion: nil)
        decksCenter.updateElement(deck, at: currentIndex)
        tableView.reloadData()
    }
}
