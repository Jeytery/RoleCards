//
//  DeckViewController.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit

protocol PlayersCountViewControllerDelegate: AnyObject {
    func playersCountViewController(didChoosePlayers count: Int)
}

class PlayersCountViewController: UIViewController {
    
    weak var delegate: PlayersCountViewControllerDelegate?
    
    private let playersCountView = PlayerCountView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Colors.background
        configurePlayersCountView()
        configurePlayersLabel()
        configureNextButton()
        title = "Players count"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ui
extension PlayersCountViewController {
    private func configurePlayersCountView() {
        view.addSubview(playersCountView)
        playersCountView.translatesAutoresizingMaskIntoConstraints = false
        playersCountView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playersCountView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playersCountView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        playersCountView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playersCountView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func configureNextButton() {
        let nextButton = UIButton()
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.setBottomConstraint(self, constant: -30)
        nextButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        nextButton.setPrimaryStyle(icon: Icons.vector, color: Colors.primary)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchDown)
    }
    
    @objc func nextButtonAction() {
        delegate?.playersCountViewController(didChoosePlayers: playersCountView.value)
    }
    
    private func configurePlayersLabel() {
        let playersLabel = UILabel()
        view.addSubview(playersLabel)
        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        playersLabel.text = "Players"
        playersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playersLabel.bottomAnchor.constraint(equalTo: playersCountView.topAnchor, constant: -30).isActive = true
        playersLabel.font = .systemFont(ofSize: 25, weight: .semibold)
    }
}

fileprivate class PlayerCountView: UIView {
    
    private(set) var value: Int = 1 {
        didSet { countLabel.text = String(value) }
    }
    
    private let plusButton = UIButton()
    private let minusButton = UIButton()
    private let countLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(countLabel)
        countLabel.font = .systemFont(ofSize: 130, weight: .semibold)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        countLabel.text = "1"
        
        addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.rightAnchor.constraint(equalTo: countLabel.leftAnchor, constant: -25).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        minusButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        minusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(Colors.text, for: .normal)
        minusButton.layer.cornerRadius = DesignProperties.cornerRadius
        minusButton.backgroundColor = Colors.interface
        
        addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.leftAnchor.constraint(equalTo: countLabel.rightAnchor, constant: 25).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(Colors.text, for: .normal)
        plusButton.backgroundColor = Colors.interface
        plusButton.layer.cornerRadius = DesignProperties.cornerRadius
        
        plusButton.addTarget(self, action: #selector(plusButtonAction), for: .touchDown)
        minusButton.addTarget(self, action: #selector(minusButtonAction), for: .touchDown)
    }
    
    @objc func plusButtonAction() {
        guard value < 99 else { return }
        value += 1
    }
    
    @objc func minusButtonAction() {
        guard value > 1 else { return }
        value -= 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
