
//
//  RoomViewController.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit

protocol RoomViewControllerDelegate: AnyObject {
    func roomViewController(_ viewController: UIViewController, didSendEventsFor room: Room)
    func roomViewController(_ viewController: UIViewController, didDelete room: Room)
}

class RoomViewController: UIViewController {

    var delegate: RoomViewControllerDelegate?
    
    private var viewModel: RoomViewModel!
    
    private let titleStackView = UIStackView()
    private var list: UICollectionView!
    private let playersCountLabel = UILabel()
    
    init(room: Room, roles: Roles) {
        super.init(nibName: nil, bundle: nil)
        configureViewModel(room: room, roles: roles)
        configureUI()
        configureTitles(room)
        configureList()
        configureBottomButtons()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - ui
extension RoomViewController {
    private func configureViewModel(room: Room, roles: Roles) {
        viewModel = RoomViewModel(room: room, roles: roles)
        viewModel.observeUsers(onUpdate: {
            [unowned self] users in
            list?.reloadData()
            playersCountLabel.text = viewModel.playersCount
        })
    }
    
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
        let nameTitle = BigTitleView(firstTitle: "Name", secondTitle: room.name)
        let passwordTitle = BigTitleView(firstTitle: "Password", secondTitle: room.password ?? "")
        
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
        playersCountLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        playersCountLabel.textColor = .gray
        playersCountLabel.text = viewModel.playersCount
    
        view.addSubview(playersCountLabel)
        playersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        playersCountLabel.setSideConstraints(self, constant: 20)
        playersCountLabel.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.topAnchor.constraint(equalTo: playersCountLabel.bottomAnchor, constant: 20).isActive = true
        list.setSideConstraints(self, constant: 20)
        
        list.delegate = self
        list.dataSource = self
        list.register(UserCell.self, forCellWithReuseIdentifier: "cell")
        list.backgroundColor = Colors.background
    }
    
    private func configureBottomButtons() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 20).isActive = true
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
        
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchDown)
        dismissButton.addTarget(self, action: #selector(dismissButtonAction), for: .touchDown)
    }
    
    @objc func confirmButtonAction() {
        viewModel.sendEvents()
        delegate?.roomViewController(self, didDelete: viewModel.room)
    }
    
    @objc func dismissButtonAction() {
        viewModel.removeRoom()
        delegate?.roomViewController(self, didSendEventsFor: viewModel.room)
    }
}

//MARK: - [d] list
extension RoomViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return viewModel.users.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath)
                                                      as! UserCell
        let user = viewModel.users[indexPath.row]
        cell.setUser(user, index: indexPath.row)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width - 40, height: 100)
    }
}
