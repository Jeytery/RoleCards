//
//  DeckDisplayViewController.swift
//  RoleCards
//
//  Created by Jeytery on 04.03.2022.
//

import UIKit

protocol DecksDisplayerViewControllerDelegate: AnyObject {
    func decksDisplayerViewController(
        _ viewController: DecksDisplaerViewController,
        tableView: UITableView,
        didDeletedAt indexPath: IndexPath
    )
    
    func decksDisplayerViewController(
        _ viewController: DecksDisplaerViewController,
        didSelectedAt indexPath: IndexPath
    )
    
    func decksDisplayerShouldDisplayDecks(
        _ viewController: DecksDisplaerViewController
    ) -> Decks
}

extension DecksDisplayerViewControllerDelegate {
    func decksDisplayerViewController(
        _ viewController: DecksDisplaerViewController,
        tableView: UITableView,
        didDeletedAt indexPath: IndexPath
    ) {}
}

class DecksDisplaerViewController: UIViewController {
    
    weak var delegate: DecksDisplayerViewControllerDelegate?
    
    private let tableView = StateTableView(title: "No decks...")
    
    private var decks: Decks {
        return delegate?.decksDisplayerShouldDisplayDecks(self) ?? []
    }
    
    private var tableViewImpl: DeckTableImpl!
     
    init(deletable: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.tableViewImpl = deletable ? DeletableDeckTableImpl(delegate: self) : DeckTableImpl(delegate: self)
        configureTableView()
        view.backgroundColor = tableView.backgroundColor
    }
    
    func reload() { tableView.reloadData() }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension DecksDisplaerViewController {
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setTopConstraint(   self)
        tableView.setSideConstraints( self)
        tableView.setBottomConstraint(self)
        
        tableView.register(TableCell<DeckView>.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = tableViewImpl
        tableView.dataSource = tableViewImpl
    }
}

extension DecksDisplaerViewController: DeckTableImplDelegate {
    func deckTableImpl(
        _ implementation: DeckTableImpl,
        tableView: UITableView,
        didDeletedAt indexPath: IndexPath
    ) {
        delegate?.decksDisplayerViewController(self, tableView: tableView, didDeletedAt: indexPath)
    }
    
    func deckTableImpl(
        _ implementation: DeckTableImpl,
        didSelectedAt indexPath: IndexPath
    ) {
        delegate?.decksDisplayerViewController(self, didSelectedAt: indexPath)
    }
    
    func deckTableImplShouldDisplayDecks(
        _ implementation: DeckTableImpl
    ) -> Decks {
        return decks
    }
}

protocol DeckTableImplDelegate: AnyObject {
    func deckTableImpl(
        _ implementation: DeckTableImpl,
        tableView: UITableView,
        didDeletedAt indexPath: IndexPath
    )
    
    func deckTableImpl(
        _ implementation: DeckTableImpl,
        didSelectedAt indexPath: IndexPath
    )
    
    func deckTableImplShouldDisplayDecks(
        _ implementation: DeckTableImpl
    ) -> Decks
}

extension DeckTableImplDelegate {
    func deckTableImpl(
        _ implementation: DeckTableImpl,
        tableView: UITableView,
        didDeletedAt indexPath: IndexPath
    ) {}
}

class DeckTableImpl: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: DeckTableImplDelegate?
    
    private var decks: Decks { return delegate?.deckTableImplShouldDisplayDecks(self) ?? [] }
    
    private let cellHeight: CGFloat = 100
    
    init(delegate: DeckTableImplDelegate) {
        self.delegate = delegate
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return decks.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! TableCell<DeckView>
        
        let deck = decks[indexPath.row]
        cell.baseView.setDeck(deck)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.deckTableImpl(self, didSelectedAt: indexPath)
    }
}
 
class DeletableDeckTableImpl: DeckTableImpl {
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle != .delete { return }
        delegate?.deckTableImpl(self, tableView: tableView, didDeletedAt: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

