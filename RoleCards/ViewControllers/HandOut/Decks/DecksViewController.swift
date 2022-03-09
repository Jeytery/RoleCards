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
    
    private let deckDisplayerVC = DecksDisplaerViewController(deletable: true)
    
    private var currentIndex: Int = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
        configureAddButton()
        configureDeckDisplayerVC()
    }

    required init?(coder: NSCoder) { fatalError() }
}

extension DecksViewController {
    private func configureUI() {
        view.backgroundColor = tableView.backgroundColor
        title = "Decks"
    }

    private func configureDeckDisplayerVC() {
        addChild(deckDisplayerVC)
        view.addSubview(deckDisplayerVC.view)
        
        deckDisplayerVC.view.translatesAutoresizingMaskIntoConstraints = false
        deckDisplayerVC.view.setTopConstraint(self)
        deckDisplayerVC.view.setSideConstraints(self)
        deckDisplayerVC.view.setBottomConstraint(self)
        
        deckDisplayerVC.didMove(toParent: self)
        deckDisplayerVC.delegate = self
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
        deckDisplayerVC.reload()
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

//MARK: - [d] deckDispalyerVC
extension DecksViewController: DecksDisplayerViewControllerDelegate {
    func decksDisplayerShouldDisplayDecks(
        _ viewController: DecksDisplaerViewController
    ) -> Decks {
        return decksCenter.data
    }

    func decksDisplayerViewController(
        _ viewController: DecksDisplaerViewController,
        didSelectedAt indexPath: IndexPath
    ) {
        let deck = decksCenter.data[indexPath.row]
        currentIndex = indexPath.row

        let deckVC = DeckViewController(deck: deck)
        deckVC.delegate = self

        let nvc = BaseNavigationController(
            rootViewController: deckVC,
            buttonSide: .left,
            withBigTitle: false
        )
        
        present(nvc, animated: true, completion: nil)
    }
    
    func decksDisplayerViewController(
        _ viewController: DecksDisplaerViewController,
        tableView: UITableView,
        didDeletedAt indexPath: IndexPath
    ) {
        decksCenter.removeElement(at: indexPath.row)
    }
    
    func decksDispalyerShouldAllowDelete(_ viewController: UIViewController) -> Bool { return true }
}

//MARK: - [d] deckVC
extension DecksViewController: DeckViewControllerDelegate {
    func deckViewController(_ viewController: UIViewController, didTapSaveButtonWith deck: Deck) {
        viewController.dismiss(animated: true, completion: nil)
        decksCenter.updateElement(deck, at: currentIndex)
        deckDisplayerVC.reload()
    }
}
