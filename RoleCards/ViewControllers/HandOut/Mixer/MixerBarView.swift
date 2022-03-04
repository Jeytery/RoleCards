//
//  MixerBarView.swift
//  RoleCards
//
//  Created by Jeytery on 03.03.2022.
//

import UIKit

fileprivate class CircleIconView: UIView {
    
    var didTap: (() -> Void)? = nil
    
    private let iconImageView = UIImageView()
    
    init(icon: UIImage, color: UIColor, constant: CGFloat) {
        super.init(frame: .zero)
        backgroundColor = color
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        iconImageView.widthAnchor.constraint(equalToConstant: constant).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: constant).isActive = true
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = icon
        iconImageView.tintColor = Colors.text
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @objc func tapAction() {
        didTap?()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

protocol MixerBarViewDelegate: AnyObject {
    func mixerBarView(_ mixerBar: MixerBarView, didTapTrash   view: UIView)
    func mixerBarView(_ mixerBar: MixerBarView, didTapAddCard view: UIView)
    func mixerBarView(_ mixerBar: MixerBarView, didTapAddDeck view: UIView)
    func mixerBarView(_ mixerBar: MixerBarView, didTapShuffle view: UIView)
}

class MixerBarView: UIView {
    
    weak var delegate: MixerBarViewDelegate?
    
    private let list = UIStackView()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.topAnchor.constraint(equalTo: topAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        list.axis = .horizontal
        list.distribution = .fillEqually
        list.spacing = 10
        
        let trashView = CircleIconView(icon: Icons.trash, color: Colors.background, constant: 20)
        trashView.translatesAutoresizingMaskIntoConstraints = false
        trashView.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        let addCardView = CircleIconView(icon: Icons.addCard, color: Colors.background, constant: 40)
        let addDeckView = CircleIconView(icon: Icons.addDeck, color: Colors.background, constant: 40)
        let shuffleView = CircleIconView(icon: Icons.shuffle, color: Colors.background, constant: 20)
        
        list.addArrangedSubview(trashView)
        list.addArrangedSubview(addCardView)
        list.addArrangedSubview(addDeckView)
        list.addArrangedSubview(shuffleView)
        
        trashView.didTap = {
            [unowned self] in
            delegate?.mixerBarView(self, didTapTrash: trashView)
        }
        
        addCardView.didTap = {
            [unowned self] in
            delegate?.mixerBarView(self, didTapAddCard: addCardView)
        }
        
        addDeckView.didTap = {
            [unowned self] in
            delegate?.mixerBarView(self, didTapAddDeck: addDeckView)
        }
        
        shuffleView.didTap = {
            [unowned self] in
            delegate?.mixerBarView(self, didTapShuffle: shuffleView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
