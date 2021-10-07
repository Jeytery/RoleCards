//
//  MultiplayerViewController.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit
import FirebaseDatabase

class MultiplayerViewController: UIViewController {
    
    private let database = Database.database().reference().child("rooms")
    
    private var autorizationVC: AutorizationViewContoller!
    private let addRoomButton = UIButton()
    private let list = StateCollectionView()

    private var rooms: [Room] = [] {
        didSet {
            DispatchQueue.main.async { [list] in list.reloadData() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureUI()
        configureUserManager()
        configureList()
        configureAddRoomButton()
        configureObserver()
        getRooms(completion: {
            [weak self] result in
            switch result {
            case .success(let rooms):
                self?.rooms = rooms
                break
            case .failure(let error):
                print("getRooms: \(error)")
                break
            }
        })
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
        list.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
        let deckNC = DeckNavigationController()
        deckNC.deckDelegate = self
        present(deckNC, animated: true, completion: nil)
    }
}

//MARK: - [d] deckNC
extension MultiplayerViewController: DeckNavigationControllerDelegate {
    func deckNavigationContoller(_ viewController: UIViewController, roles: Roles, room: Room) {
        viewController.dismiss(animated: true, completion: nil)
        present(RoomViewController(room: room, roles: roles), animated: true, completion: nil)
    }
}

//MARK: - internal functions
extension MultiplayerViewController {
    private func configureUserManager() {
        LoadingState.start()
        UserManager.shared.delegate = self
        UserManager.shared.configure()
    }
    
    private func configureObserver() {
        database.observe(.value, with: {
            [weak self] datasnapshot in
            print("rooms changed")
            guard let dict = datasnapshot.value as? [String: Any] else { return }
            let rooms = parseJsonToRooms(dict)
            self?.rooms = rooms
        })
    }
}

//MARK: - [D] UserManager
extension MultiplayerViewController: UserManagerDelegate {
    func userManager(didGet user: User) {}
    
    func userManagerDidNotGetUser() {
        DispatchQueue.main.async {
            [unowned self] in 
            autorizationVC = AutorizationViewContoller()
            autorizationVC.delegate = self
            let nvc = BaseNavigationController(rootViewController: autorizationVC)
            nvc.modalPresentationStyle = .overCurrentContext
            present(nvc, animated: false, completion: nil)
        }
    }
    
    func userManagerDidAutorize() { LoadingState.stop() }
}

//MARK: - [d] AutorizationVC
extension MultiplayerViewController: AutorizationViewControllerDelegate {
    func autorizationViewControllerDidAutorized() {
        autorizationVC.dismiss(animated: true, completion: nil)
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
        return rooms.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! RoomCell
        cell.backgroundColor = Colors.lightGray
        cell.room = rooms[indexPath.row]
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
}

class RoomCell: UICollectionViewCell {
    
    var room: Room {
        get { roomView.room }
        set { roomView.room = newValue }
    }
    
    private let roomView = RoomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(roomView)
        roomView.translatesAutoresizingMaskIntoConstraints = false
        roomView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        roomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        roomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
