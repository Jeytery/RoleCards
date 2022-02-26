//
//  CardsStackView.swift
//  RoleCards
//
//  Created by Jeytery on 11.02.2022.
//

import UIKit
import Pikko

class CardsStackView: UIView {

    weak var delegate: CardsStackViewDelegate?
    
    // constants
    private let cardsAmount = 3
    private let positionDelta: Double = 15
    private let cardsAlpha = 0.3
    
    private var currentIndex = 0
    
    private func stackPosition(index: Int) -> Double {
        return positionDelta * Double(index)
    }
    
    private let stackColors: [UIColor] = [
            UIColor(red: 66/255, green: 135/255, blue: 245/255, alpha: 1),
            UIColor(red: 240/255, green: 58/255, blue: 58/255, alpha: 1),
            UIColor(red: 58/255, green: 240/255, blue: 173/255, alpha: 1)
    ]

    // state var
    private(set) var currentCards: [UIView] = []

    init() {
        super.init(frame: .zero)
        createStack()
    }

    required init?(coder: NSCoder) { fatalError() }
}

//MARK: - utils
extension CardsStackView {
    private func animate(_ animation: @escaping () -> Void, completion: (() -> Void)? = nil) {
        UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 1.0,
        options: .curveEaseIn,
        animations: {
            animation()
        }, completion: { _ in completion?() })
    }

    private func animate(_ animation: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseIn,
                       animations: animation)
    }
}

//MARK: - stack logic
extension CardsStackView {
    private func ColorView() -> UIView {
        let view = UIView()
        view.backgroundColor = stackColors.randomElement()
        view.layer.cornerRadius = DesignProperties.cornerRadius
        return view
    }
    
    private func recountStackScale() {
        for i in 0 ..< currentCards.count {
            let card = currentCards[i]
            self.updateViewConstraints(index: i, view: card)
        }

        animate {
            self.layoutIfNeeded()
        }
    }

    private func updateViewConstraints(index: Int, view: UIView) {
        let constant = stackPosition(index: index)
        let negativeConstraints = view.superview?.constraints.filter {
            ($0.firstItem as? UIView) == view &&
            ($0.firstAttribute == .bottom ||
            $0.firstAttribute == .left   ||
            $0.firstAttribute == .top)
        }

        let positiveConstraints = view.superview?.constraints.filter {
            ($0.firstItem as? UIView) == view &&
            $0.firstAttribute == .right
        }

        positiveConstraints?.forEach {
            $0.constant = -constant
        }

        negativeConstraints?.forEach {
            $0.constant = constant
        }
    }

    private func addConstraints(for index: Int, view: UIView) {
        let constant = stackPosition(index: index)
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: constant).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: -1 * constant).isActive = true
    }

    private func addStackConstraints(view: UIView) {
        addConstraints(for: currentCards.count - 1, view: view)
    }

    private func addToStack(view: UIView) {
        addSubview(view)
        currentCards.append(view)
        addStackConstraints(view: view)
        sendSubviewToBack(view)
    }

    private func createStack() {
        for i in 0 ..< cardsAmount {
            let card = ColorView()
            addToStack(view: card)
            if i > 0 { card.alpha = cardsAlpha }
        }
    }
}

extension CardsStackView {
//    private func upStack() {
//        currentIndex -= 1
//        for i in 0 ..< currentCards.count {
//            let index = i// + currentIndex
//            let card = currentCards[i]
//            updateViewConstraints(index: index, view: card)
//        }
//        animate {
//            self.superview?.layoutIfNeeded()
//        }
//        completion: {
//            self.delegate?.cardStackView(stack: self,
//                                         didEndAnimationWith: self.currentCards)
//        }
//    }
    
    private func updateCardIndexes(add value: Int) {
        for i in 0 ..< currentCards.count {
            let index = i + value
            print(index)
            let card = currentCards[i]
            updateViewConstraints(index: index, view: card)
        }
        
        animate {
            self.superview?.layoutIfNeeded()
        }
        completion: {
            self.delegate?.cardStackView(stack: self,
                                         didEndAnimationWith: self.currentCards)
        }
    }
    
    func upStack() {
        currentIndex -= 1
        updateCardIndexes(add: currentIndex)
    }
    
    func nextCard() {
        let colorView = ColorView()
        colorView.frame = currentCards[currentCards.count - 1].frame
        colorView.alpha = 0
        
        addSubview(colorView)
        addStackConstraints(view: colorView)
        currentCards.append(colorView)
        
        upStack()
        
        animate {
            colorView.alpha = self.cardsAlpha
        }
    }

    func hideTopCard() {
        guard !currentCards.isEmpty else { return }
        currentCards[0].isHidden = true
    }
    
    // pop last index
    func popCard() {
        let card = currentCards[0]
        card.removeFromSuperview()
        currentCards.removeFirst()
    }
    
    // pop first index
    func popStack() {
        popCard()
        currentIndex += 1
    }
}

protocol CardsStackViewDelegate: AnyObject {
    func cardStackView(stack: CardsStackView, didEndAnimationWith cards: [UIView])
}


























protocol CardsStackable {
    
    // stack core
    func setConstraints(_ view: UIView, for index: Int)
    func addConstraints(_ view: UIView, for index: Int)
    
    // utils
    func animate(_ animation: @escaping () -> Void, completion: (() -> Void)?)
    func animate(_ animation: @escaping () -> Void)
    
    // stack logic
    func spawnCard()
    func upStack()
}

protocol _CardsStackViewDelegate: AnyObject {
    func cardStackView(stack: _CardsStackView, didEndAnimationWith cards: [UIView])
}

class _CardsStackView: UIView {
    
    weak var delegate: _CardsStackViewDelegate?

    // state
    private(set) var currentCards: [UIView] = []
    private(set) var level: Int = 0

    // constants
    private let positionDelta: Double = 15
    private let cardsAlpha: Double = 0.3
    
    private let stackColors: [UIColor] = [
        UIColor(red: 66/255, green: 135/255, blue: 245/255, alpha: 1),
        UIColor(red: 240/255, green: 58/255, blue: 58/255, alpha: 1),
        UIColor(red: 58/255, green: 240/255, blue: 173/255, alpha: 1)
    ]
}

// utils
extension _CardsStackView {
    private func animate(_ animation: @escaping () -> Void, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: {
                animation()
            }, completion: { _ in completion?() }
        )
    }

    private func animate(_ animation: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: animation
        )
    }
}


// stack core
extension _CardsStackView {
    private func stackPosition(index: Int) -> Double {
        return positionDelta * Double(index)
    }
    
    private func getPositiveConstraints(_ view: UIView) -> [NSLayoutConstraint]? {
        return view
            .superview?
            .constraints
            .filter {
                ($0.firstItem as? UIView) == view &&
                ($0.firstAttribute == .bottom ||
                 $0.firstAttribute == .left   ||
                 $0.firstAttribute == .top)
            }
    }
    
    private func getNegativeConstraints(_ view: UIView) -> [NSLayoutConstraint]? {
        return view
            .superview?
            .constraints
            .filter {
                ($0.firstItem as? UIView) == view &&
                $0.firstAttribute == .right
            }
    }
    
    private func upConstraints(_ views: [UIView], for constant: CGFloat) {
        views.forEach { view in
            let negativeConstraints = getNegativeConstraints(view)
            let positiveConstraints = getPositiveConstraints(view)
            positiveConstraints?.forEach { $0.constant -= constant }
            negativeConstraints?.forEach { $0.constant += constant }
        }
    }
    
    private func addConstraints(_ view: UIView, for index: Int) {
        let constant = stackPosition(index: index)
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: constant).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: -constant).isActive = true
    }
}

// stack logic
extension _CardsStackView {
    private func ColorView() -> UIView {
        let view = UIView()
        view.backgroundColor = stackColors.randomElement()
        view.layer.cornerRadius = DesignProperties.cornerRadius
        return view
    }
    
    func upStack(animated: Bool = true) {
        upConstraints(currentCards, for: positionDelta)
        level += 1
        
        guard animated else { return self.layoutIfNeeded() }
        
        animate {
            self.layoutIfNeeded()
        }
        completion: { [unowned self] in
            delegate?.cardStackView(stack: self, didEndAnimationWith: currentCards)
        }
    }
    
    func spawnCard(animated: Bool = true) {
        let colorView = ColorView()
        colorView.frame = currentCards.last?.frame ?? .zero
        colorView.alpha = 0
        
        addSubview(colorView)
        addConstraints(colorView, for: currentCards.count - level)
        currentCards.append(colorView)
        
        sendSubviewToBack(colorView)
        
        guard animated else {
            if currentCards.isEmpty {
                colorView.alpha = 1
            }
            else {
                colorView.alpha = cardsAlpha
            }
            return
        }
        
        animate {
            [unowned self] in colorView.alpha = cardsAlpha
            
            if currentCards.isEmpty {
                colorView.alpha = 1
            }
            else {
                colorView.alpha = cardsAlpha
            }
        }
    }
    
    func removeFirstView() {
        level -= 1
        currentCards[0].removeFromSuperview()
        currentCards.removeFirst()
    }
}





//
//class CardsStackView: UIView {
//    
//    weak var delegate: CardsStackViewDelegate?
//    
//    private(set) var currentCards: [UIView] = []
//    private var stackIndex: Int = -1
//    
//    private let cardsCount = 2
//    private let cardsAlpha: CGFloat = 0.4
//    private let positionDelta: CGFloat = 12
//    
//    private let stackColors: [UIColor] = [
//        UIColor(red: 66/255, green: 135/255, blue: 245/255, alpha: 1),
//        UIColor(red: 240/255, green: 58/255, blue: 58/255, alpha: 1),
//        UIColor(red: 58/255, green: 240/255, blue: 173/255, alpha: 1)
//    ]
//    
//    init() {
//        super.init(frame: .zero)
//        createStack()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setStackFrames()
//    }
//}
//
//extension CardsStackView {
//    private func animate(_ animation: @escaping () -> Void, completion: (() -> Void)? = nil) {
//        UIView.animate(
//        withDuration: 0.5,
//        delay: 0,
//        usingSpringWithDamping: 1.0,
//        initialSpringVelocity: 1.0,
//        options: .curveEaseIn,
//        animations: {
//            animation()
//        }, completion: { _ in completion?() })
//    }
//
//    private func animate(_ animation: @escaping () -> Void) {
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: 1.0,
//                       initialSpringVelocity: 1.0,
//                       options: .curveEaseIn,
//                       animations: animation)
//    }
//}
//
////MARK: - stack utils
//extension CardsStackView {
//    private func ColorView() -> UIView {
//        let view = UIView()
//        view.backgroundColor = stackColors.randomElement()
//        view.layer.cornerRadius = DesignProperties.cornerRadius + 10
//        return view
//    }
//
//    private func setFrame(scale: Int, view: UIView) {
//        let width = frame.width - (positionDelta * .init(scale) * 2)
//        let x = bounds.minX + (positionDelta * .init(scale))
//        let y = bounds.minY + (positionDelta * .init(scale))
//
//        let frame = CGRect(
//            x: x,
//            y: y,
//            width: width,
//            height: frame.height
//        )
//        view.frame = frame
//    }
//    
//    private func setAlpha() {
//        currentCards.forEach {
//            $0.alpha = self.cardsAlpha
//        }
//        //currentCards[0].alpha = 1
//    }
//}
//
//extension CardsStackView {
//    private func createStack() {
//        for _ in 0 ..< cardsCount {
//            let colorView = ColorView()
//            addToStack(view: colorView)
//        }
//        setAlpha()
//    }
//    
//    private func setStackFrames() {
//        for i in 0 ..< currentCards.count {
//            let view = currentCards[i]
//            setFrame(scale: i - .init(stackIndex), view: view)
//        }
//    }
//    
//    private func addToStack(view: UIView) {
//        currentCards.append(view)
//        addSubview(view)
//        sendSubviewToBack(view)
//    }
//}
//
//extension CardsStackView {
//    func upStack() {
//        let colorView = ColorView()
//        colorView.frame = currentCards[currentCards.count - 1].frame
//        colorView.alpha = 0
//        
//        addToStack(view: colorView)
//        stackIndex += 1
//        
//        animate {
//            self.setStackFrames()
//            colorView.alpha = self.cardsAlpha
//        }
//        completion: {
//            [weak self] in
//            guard let self = self else { return }
//            self.delegate?.cardStackView(stack: self,
//                                         didEndAnimationWith: self.currentCards)
//        }
//        
//        setAlpha()
//    }
//    
//    func hideTopCard() {
//        currentCards[0].isHidden = true
//    }
//    
//    func popCard() {
//        currentCards.remove(at: 0)
//    }
//}
