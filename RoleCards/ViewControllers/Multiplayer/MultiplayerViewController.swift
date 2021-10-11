//
//  MultiplayerViewController.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit
import FirebaseDatabase

class MultiplayerViewController: UIViewController {

    private var presenter: MultiplayerViewControllerPresenter!
    
    private let addRoomButton = UIButton()
    private let list = StateCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MultiplayerViewControllerPresenter(with: self)
        configureUI()
        configureList()
        configureAddRoomButton()
    }
}

//MARK: - ui
extension MultiplayerViewController {
    private func configureUI() {
        view.backgroundColor = Colors.background
        title = "Rooms"
    }
    
    private func configureList() {
        list.delegate = self
        list.dataSource = self
        list.register(RoomCell.self,
                      forCellWithReuseIdentifier: "cell")
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.setTopConstraint(self, constant: 20)
        list.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func configureAddRoomButton() {
        view.addSubview(addRoomButton)
        addRoomButton.translatesAutoresizingMaskIntoConstraints = false
        addRoomButton.setPrimaryStyle()
        addRoomButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addRoomButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addRoomButton.setBottomConstraint(self, constant: -20)
        addRoomButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 20).isActive = true
        addRoomButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addRoomButton.setTitle("Add room", for: .normal)
        addRoomButton.addTarget(self, action: #selector(addRoomButtonAction), for: .touchDown)
    }
    
    @objc func addRoomButtonAction() {        
        presenter.addRoomButtonAction()
    }
}

//MARK: - [d] presenter
extension MultiplayerViewController: MultiplayerViewControllerPresenterDelegate {
    func showTextFieldAlert(onDone: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Enter room's password, please"
        })
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {
            _ in
            let textField = alert.textFields![0]
            onDone(textField.text ?? "")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showInfoAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {_ in }))
        present(alert, animated: true, completion: nil)
    }
    
    func startLoading() {
        LoadingState.start()
    }
    
    func stopLoading() {
        LoadingState.stop()
    }
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presenter(didUpdate rooms: Rooms) {
        list.reloadData()
    }
}

//MARK: - [d] list
extension MultiplayerViewController:
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource
{
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return presenter.rooms.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! RoomCell
        cell.backgroundColor = Colors.lightGray
        cell.room = presenter.rooms[indexPath.row]
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapOnRoomCell(index: indexPath.row)
    }
}
