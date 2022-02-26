//
//  CardsStackViewController.swift
//  RoleCards
//
//  Created by Jeytery on 11.02.2022.
//

import UIKit

class CardsStackViewController: UIViewController {

    private let roles: Roles
    
    private let floatingGesture = FloatingGesture()
    
    // all ui
    private var currentCardView: CardView!
    private var nextCardView:    CardView?
    private var indexLabel: UILabel!
    private let goodGameLabel = UILabel()
    
    // state vars
    private var roleIndex: Int = 0
    
    init(roles: Roles) {
        self.roles = roles
        super.init(nibName: nil, bundle: nil)
        
         view.backgroundColor = Colors.background
        
        floatingGesture.delegate = self
        
        configureCard()
        configureIndexLabel()
        configureGoodGameLabel()
    }

    required init?(coder: NSCoder) { fatalError() }
}

//MARK: - ui configuration
extension CardsStackViewController {
    private func configureGoodGameLabel() {
        goodGameLabel.text = "That's all. Good game!"
        goodGameLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        goodGameLabel.textColor = Colors.secondaryInterface
        goodGameLabel.textAlignment = .center
        
        view.addSubview(goodGameLabel)
        goodGameLabel.translatesAutoresizingMaskIntoConstraints = false
        goodGameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        goodGameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goodGameLabel.alpha = 0
    }
    
    private func configureIndexLabel() {
        indexLabel = UILabel()
        indexLabel.text = "\(roleIndex + 1) of \(roles.count)"
        indexLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        indexLabel.textColor = Colors.secondaryInterface
        indexLabel.textAlignment = .center
        
        view.addSubview(indexLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.setBottomConstraint(self, constant: -30)
        indexLabel.setSideConstraints(self)
    }
    
    private func configureCard() {
        currentCardView = CardView(role: roles[roleIndex], mainColor: cardColor)
        view.addSubview(currentCardView)
        currentCardView.translatesAutoresizingMaskIntoConstraints = false
        currentCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        currentCardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 7/11).isActive = true
        currentCardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        currentCardView.addGesture(floatingGesture)
    }
}

//MARK: - ui logic
extension CardsStackViewController {
    private func popIndexLabelIndex() {
        roleIndex -= 1
        indexLabel.text = "\(roleIndex + 1) of \(roles.count)"
    }
    
    private func setIndexLabelIndex() {
        roleIndex += 1
        if roleIndex > roles.count - 1{ return }
        indexLabel.text = "\(roleIndex + 1) of \(roles.count)"
    }
    
    private func setEndState() {
        UIView.animate {
            [self] in
            goodGameLabel.alpha = 1
            indexLabel.alpha = 0
        }
    }

    private func animate(_ animation: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: animation
        )
    }
}

//MARK: - stack logic
extension CardsStackViewController {
    private var cardColor: UIColor {
        return Colors.patColors.randomElement() ?? Colors.green
    }
    
    private func showNextCard() {
        nextCardView = CardView(role: roles[roleIndex], mainColor: cardColor)
        
        view.addSubview(nextCardView!)
        
        nextCardView!.translatesAutoresizingMaskIntoConstraints = false
        nextCardView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextCardView!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nextCardView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 7/11).isActive = true
        nextCardView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        
        nextCardView!.alpha = 0
        nextCardView!.transform = .init(scaleX: 0.1, y: 0.1)
        
        view.sendSubviewToBack(nextCardView!)
        
        animate {
            [self] in
            nextCardView?.alpha = 0.5
            nextCardView?.transform = .init(scaleX: 0.4, y: 0.4)
        }
    }
    
    private func hideNextCard() {
        animate {
            [self] in
            nextCardView?.alpha = 0
            nextCardView?.transform = .init(scaleX: 0.1, y: 0.1)
        }
    }
    
    private func showFullSizeNextCard() {
        animate {
            [self] in
            nextCardView?.alpha = 1
            nextCardView?.transform = .init(scaleX: 1, y: 1)
        }
    }
}

extension CardsStackViewController: FloatingGestureDelegate {
    func floatingGesture(_ gesture: FloatingGesture, didEndWith card: UIView) {
        hideNextCard()
        popIndexLabelIndex()
        animate {
            [self] in
            indexLabel.alpha = 1
        }
    }
    
    func floatingGesture(_ gesture: FloatingGesture, didEndWithout card: UIView) {
        if roleIndex == roles.count { return setEndState() }
        
        showFullSizeNextCard()

        currentCardView.gestureRecognizers?.removeAll()
        currentCardView = nextCardView
        currentCardView?.addGesture(floatingGesture)
        nextCardView = nil
    }
     
    func floatingGestureDidStart(_ gesture: FloatingGesture) {
        setIndexLabelIndex()
        if roleIndex == roles.count { return }
        showNextCard()
    }
    
    func floatingGesutre(
        _ gesture: FloatingGesture,
        didChangedWith yOffset: CGFloat,
        with range: ClosedRange<CGFloat>
    ) {
        let toDiaposon: ClosedRange<CGFloat> = 0.4 ... 0.9
        var offset = yOffset
        
        if offset < 0 { offset = -offset }
        if offset > range.upperBound { offset = range.upperBound }
        
        let cardScale = Math.mapDiaposons(value: offset, from: range, to: toDiaposon)

        nextCardView?.transform = .init(scaleX: cardScale, y: cardScale)
    }
    
    func floatingGesture(
        _ gesture: FloatingGesture,
        didEndAnimation isWithCard: Bool
    ) {
        currentCardView?.addGesture(floatingGesture)
    }
}
