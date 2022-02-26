//
//  CardsViewController.swift
//  RoleCards
//
//  Created by Jeytery on 12.10.2021.
//

import UIKit

class CardsViewController: UIViewController {
    
    private let roles: Roles
    
    private let playerLabel = UILabel()
    
    init(roles: Roles) {
        self.roles = roles
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureList()
        conifigureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ui
extension CardsViewController {
    private func conifigureUI() {
        view.backgroundColor = Colors.background
    }
    
    private func configureList() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.delegate = self
        list.dataSource = self
        list.backgroundColor = Colors.background
        
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.setFullScreenConstraints(self)
        list.isPagingEnabled = true
        
        list.register(CardCell.self, forCellWithReuseIdentifier: "cell")
    }
}

//MARK: - list delegate, datasource
extension CardsViewController:
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
                                                      for: indexPath) as! CardCell
        cell.setRole(roles[indexPath.row])
        cell.card.isFliped = false
        cell.indexLabel.text = "Player \(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: collectionView.bounds.height
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}

fileprivate class CardCell: UICollectionViewCell {
    
    var card: CardView!
    
    func setRole(_ role: Role) {
        card.updateRole(role)
    }
    
    let indexLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(indexLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        indexLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        indexLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        indexLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        indexLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        
        card = CardView(role: Role(name: "Mafia", color: Colors.red.roleColor, description: ""))
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.topAnchor.constraint(equalTo: indexLabel.bottomAnchor, constant: 20).isActive = true
        card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        card.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        card.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

