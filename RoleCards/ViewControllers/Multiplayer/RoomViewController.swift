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
    private let room: Room
    
    private let titleStackView = UIStackView()
    private var list: UICollectionView!
    private let playersCountLabel = UILabel()
    
    private let buttonsStackView = UIStackView()
    private let dismissButton = UIButton()
    private let confirmButton = UIButton()
    
    init(room: Room) {
        self.room = room
        super.init(nibName: nil, bundle: nil)
        configureViewModel(room: room)
        configureUI()
        configureTitles(room)
        configureList()
        configureBottomButtons()
        hideConfirmButton()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - ui
extension RoomViewController {
    private func showConfirmButton() {
        buttonsStackView.addArrangedSubview(confirmButton)
    }
    
    private func hideConfirmButton() {
        confirmButton.removeFromSuperview()
    }
    
    private func configureViewModel(room: Room) {
        viewModel = RoomViewModel(room: room)
        viewModel.observeUsers(onUpdate: {
            [unowned self] users in
            list?.reloadData()
            playersCountLabel.text = viewModel.playersCount
            room.roles.count == users.count ? showConfirmButton() : hideConfirmButton()
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
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 10
        
        view.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 20).isActive = true
        buttonsStackView.setBottomConstraint(self, constant: -20)
        buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsStackView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        confirmButton.setPrimaryStyle(icon: Icons.vector, color: Colors.primary, constant: 19)
        dismissButton.setPrimaryStyle(icon: Icons.cross, color: Colors.red, constant: 15)
        
        buttonsStackView.addArrangedSubview(dismissButton)
        buttonsStackView.addArrangedSubview(confirmButton)
        
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchDown)
        dismissButton.addTarget(self, action: #selector(dismissButtonAction), for: .touchDown)
    }
    
    @objc func confirmButtonAction() {
        viewModel.sendEvents()
        viewModel.removeRoom()
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
