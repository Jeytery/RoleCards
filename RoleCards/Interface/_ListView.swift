//
//  ListView.swift
//  BuyDevider
//
//  Created by Jeytery on 16.03.2022.
//

import Foundation
import UIKit

protocol _ListViewDataSource: AnyObject {
    
    func listView(_ listView: _ListView, numberOfRowsInSection section: Int) -> Int
    
    func listView(_ listView: _ListView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

    func numberOfSections(in listView: UITableView) -> Int
    
    func listView(_ listView: _ListView, titleForHeaderInSection section: Int) -> String?

    func listView(_ listView: _ListView, titleForFooterInSection section: Int) -> String?

    func listView(_ listView: _ListView, canEditRowAt indexPath: IndexPath) -> Bool

    func listView(_ listView: _ListView, canMoveRowAt indexPath: IndexPath) -> Bool

    func sectionIndexTitles(for tableView: UITableView) -> [String]?

    func listView(_ listView: _ListView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    
    func listView(_ listView: _ListView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)

    func listView(_ listView: _ListView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
    func listView(_ listView: _ListView, cellInsetsforIndexPathAt: IndexPath) -> UIEdgeInsets
}

extension _ListViewDataSource {
    func listView(_ listView: _ListView, numberOfRowsInSection section: Int) -> Int { 0 }
    
    func listView(_ listView: _ListView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    
    func numberOfSections(in listView: UITableView) -> Int { 0 }
    
    func listView(_ listView: _ListView, titleForHeaderInSection section: Int) -> String? { nil }
 
    func listView(_ listView: _ListView, titleForFooterInSection section: Int) -> String? { nil }

    func listView(_ listView: _ListView, canEditRowAt indexPath: IndexPath) -> Bool { true }

    func listView(_ listView: _ListView, canMoveRowAt indexPath: IndexPath) -> Bool { true }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? { nil }

    func listView(_ listView: _ListView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { 0}
    
    func listView(_ listView: _ListView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}

    func listView(_ listView: _ListView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
    
    func listView(_ listView: _ListView, cellInsetsforIndexPathAt: IndexPath) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)    
    }
}

class _ListView: UITableView {
    
    private(set) var views: [UIView] = []

    weak var listDataSource: _ListViewDataSource?
    
    init(
        views: [UIView],
        frame: CGRect = .zero
    ) {
        self.views = views
        super.init(frame: .zero, style: .grouped)
        separatorStyle = .none
        super.dataSource = self
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension _ListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let insets = listDataSource?.listView(self, cellInsetsforIndexPathAt: indexPath)
        let cell = ListTableCell<UIView>(
            view: views[indexPath.section],
            edges: insets ?? .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return views.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listDataSource?.listView(self, titleForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return listDataSource?.listView(self, titleForFooterInSection: section)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return listDataSource?.listView(self, canEditRowAt: indexPath) ?? true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return listDataSource?.listView(self, canMoveRowAt: indexPath) ?? true
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return listDataSource?.sectionIndexTitles(for: tableView)
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return listDataSource?.listView(self, sectionForSectionIndexTitle: title, at: index) ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        listDataSource?.listView(self, commit: editingStyle, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        listDataSource?.listView(self, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}









fileprivate class ListTableCell<T: UIView>: UITableViewCell {
    
    var baseView: T!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView(T())
    }
    
    init(
        view: T,
        edges: UIEdgeInsets,
        style: UITableViewCell.CellStyle = .default,
        reuseIdentifier: String? = nil
    ) {
        print("TableCell.init")
        self.baseView = view
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView(baseView, edges: edges)
        backgroundColor = .clear
    }
    
    deinit {
        print("TableCell.deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(_ _view: T) {
        contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        baseView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        baseView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    func setView(_ _view: T, edges: UIEdgeInsets) {
        contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.topAnchor.constraint(equalTo: topAnchor, constant: edges.top).isActive = true
        baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -edges.bottom).isActive = true
        baseView.leftAnchor.constraint(equalTo: leftAnchor, constant: edges.left).isActive = true
        baseView.rightAnchor.constraint(equalTo: rightAnchor, constant: -edges.right).isActive = true
    }
}


//class _ListView: UITableView {
//
//    private(set) var views: [UIView] = []
//
//
//
//    private weak var _dataSource: UITableViewDataSource?
//
//    override weak var dataSource: UITableViewDataSource? {
//        get {
//            return _dataSource
//        }
//        set {
//            _dataSource = newValue
//            super.dataSource = self
//        }
//    }
//
//    override func forwardingTarget(for aSelector: Selector!) -> Any? {
//        if _dataSource?.responds(to: aSelector) == true {
//            return _dataSource
//        }
//        return super.forwardingTarget(for: aSelector)
//    }
//
//    override func responds(to aSelector: Selector!) -> Bool {
//        if let _dataSource = _dataSource {
//            return _dataSource.responds(to: aSelector)
//        }
//        return super.responds(to: aSelector)
//    }
//
//    init(
//        views: [UIView],
//        frame: CGRect = .zero
//    ) {
//        self.views = views
//        super.init(frame: .zero, style: .grouped)
//        separatorStyle = .none
//        super.dataSource = self
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//}
//
//extension _ListView: UITableViewDataSource, UITableViewDelegate {
//    func tableView(
//        _ tableView: UITableView,
//        numberOfRowsInSection section: Int
//    ) -> Int {
//        return views.count
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath
//    ) -> UITableViewCell {
//        let cell = TableCell<UIView>(
//            view: views[indexPath.row],
//            edges: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
//        )
//        return cell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return ""
//    }
//
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return ""
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        []
//    }
//
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        0
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//    }
//}
//
//
//
//
//
//
//
//
//
//class TableCell<T: UIView>: UITableViewCell {
//
//    var baseView: T!
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setView(T())
//    }
//
//    init(
//        view: T,
//        edges: UIEdgeInsets,
//        style: UITableViewCell.CellStyle = .default,
//        reuseIdentifier: String? = nil
//    ) {
//        self.baseView = view
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setView(baseView, edges: edges)
//        backgroundColor = .clear
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setView(_ _view: T) {
//        contentView.addSubview(baseView)
//        baseView.translatesAutoresizingMaskIntoConstraints = false
//        baseView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        baseView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        baseView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        baseView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//    }
//
//    func setView(_ _view: T, edges: UIEdgeInsets) {
//        contentView.addSubview(baseView)
//        baseView.translatesAutoresizingMaskIntoConstraints = false
//        baseView.topAnchor.constraint(equalTo: topAnchor, constant: edges.top).isActive = true
//        baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -edges.bottom).isActive = true
//        baseView.leftAnchor.constraint(equalTo: leftAnchor, constant: edges.left).isActive = true
//        baseView.rightAnchor.constraint(equalTo: rightAnchor, constant: -edges.right).isActive = true
//    }
//}
