//
//  DeckDisplayViewController.swift
//  RoleCards
//
//  Created by Jeytery on 04.03.2022.
//

import UIKit

protocol DeckDisplayerViewControllerDelegate: AnyObject {
    func deckDisplayerViewController(
        _ viewController: DeckDisplaerViewController,
        didDeletedAt indexPath: IndexPath
    )
    
    func deckDisplayerViewController(
        _ viewController: DeckDisplaerViewController,
        didSelectedAt indexPath: IndexPath
    )
    
    func deckDisplayerShouldDisplayDecks(
        _ viewController: DeckDisplaerViewController
    ) -> Decks
}

class DeckDisplaerViewController: UIViewController {
    
    weak var delegate: DeckDisplayerViewControllerDelegate?
    
    private let isDeleteAvailable: Bool
    private let cellHeight: CGFloat = 100

    private let tableView = StateTableView(title: "Add deck, then choose")
    
    private var decks: Decks {
        return delegate?.deckDisplayerShouldDisplayDecks(self) ?? []
    }
    
    init(isDeleteAvailable: Bool = false) {
        self.isDeleteAvailable = isDeleteAvailable
        super.init(nibName: nil, bundle: nil)
        configureTableView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension DeckDisplaerViewController {
    private func configureTableView() {
        tableView.setTopConstraint(   self)
        tableView.setSideConstraints( self)
        tableView.setBottomConstraint(self)
        
        tableView.register(TableCell<DeckView>.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate =   self
        tableView.dataSource = self
    }
}

extension DeckDisplaerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
}
