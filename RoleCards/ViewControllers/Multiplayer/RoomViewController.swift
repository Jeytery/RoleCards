
//
//  RoomViewController.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit

class RoomViewController: UIViewController {
    
    private let room: Room
    
    private let roles: Roles
    
    private let titleStackView = UIStackView()
    
    private var ss: ServiceSession!
    
    init(room: Room, roles: Roles) {
        self.room = room
        self.roles = roles
        super.init(nibName: nil, bundle: nil)
        configureUI()
        configureTitles(room)
        configureList()
        configureBottomButtons()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - ui
extension RoomViewController {
    private func Title(first: String, second: String) -> UIView {
        let titleView = UIView()
        
        let smallTitle = UILabel()
        smallTitle.font = .systemFont(ofSize: 20, weight: .semibold)
        smallTitle.textColor = .gray
        let bigTitle = UILabel()
        bigTitle.font = .systemFont(ofSize: 50, weight: .semibold)
        let stackView = UIStackView()
        
        titleView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(smallTitle)
        stackView.addArrangedSubview(bigTitle)
        
        smallTitle.text = first
        bigTitle.text = second
        return titleView
    }
    
    private func configureUI() {
        modalPresentationStyle = .overCurrentContext
        view.backgroundColor = Colors.background
    }
    
    private func configureTitles(_ room: Room) {
        let nameTitle = Title(first: "Name", second: room.name)
        let passwordTitle = Title(first: "Password", second: room.password ?? "")
        
        let isPass = room.password == "" || room.password == nil ? false : true
        
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 10
        titleStackView.axis = .vertical
        
        view.addSubview(titleStackView)
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.setSideConstraints(self, constant: 20)
        titleStackView.setTopConstraint(self, constant: 20)
        titleStackView.heightAnchor.constraint(equalToConstant: isPass ? 210 : 110).isActive = true
        
        titleStackView.addArrangedSubview(nameTitle)
        if isPass { titleStackView.addArrangedSubview(passwordTitle) }
    }
    
    private func configureList() {
        let playersCountLabel = UILabel()
        playersCountLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        playersCountLabel.textColor = .gray
        playersCountLabel.text = "Players: 3/10"
    
        view.addSubview(playersCountLabel)
        playersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        playersCountLabel.setSideConstraints(self, constant: 20)
        playersCountLabel.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.topAnchor.constraint(equalTo: playersCountLabel.bottomAnchor).isActive = true
        list.setSideConstraints(self, constant: 20)
        list.setBottomConstraint(self)
        list.delegate = self
        list.dataSource = self
    }
    
    private func configureBottomButtons() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setBottomConstraint(self, constant: -20)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let confirmButton = UIButton()
        let dismissButton = UIButton()
        
        confirmButton.setPrimaryStyle(icon: Icons.vector, color: Colors.primary, constant: 19)
        dismissButton.setPrimaryStyle(icon: Icons.cross, color: Colors.red, constant: 15)
        
        stackView.addArrangedSubview(dismissButton)
        stackView.addArrangedSubview(confirmButton)
    }
}

//MARK: - [d] list
extension RoomViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return UICollectionViewCell()
    }
}
