//
//  Stepper.swift
//  RoleCards
//
//  Created by Jeytery on 03.03.2022.
//

import UIKit
    
protocol StepperDelegate: AnyObject {
    func stepper(_ stepper: Stepper, didChange value: Double)
}

class Stepper: UIView {

    weak var delegate: StepperDelegate?
    
    struct Style {
        let backgroundColor: UIColor
        
        static let light = Style(backgroundColor: Colors.navigation)
        static let dark = Style(backgroundColor:  Colors.navigation)
    }
    
    private(set) var value: Double = 0
    
    var maxValue: Double = .infinity
    var minValue: Double = 0
    var step: Double = 1
    
    private let countLabel = UILabel()
    
    private let plusButton = UIButton()
    private let minusButton = UIButton()
    
    private let style: Style
    private let withFloatingPart: Bool
    
    init(style: Style = .light, withFloatingPart: Bool = false) {
        self.style = style
        self.withFloatingPart = withFloatingPart
        super.init(frame: .zero)
        
        configureUI()
        conifureCountLabel()
        configurePlusView()
        configureMinusView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        minusButton.layer.shadowPath = UIBezierPath(rect: minusButton.bounds).cgPath
        plusButton.layer.shadowPath = UIBezierPath(rect: minusButton.bounds).cgPath
    }
    
    func setValue(_ value: Double) {
        self.value = value
        setCountLabelText(value)
    }
}

extension Stepper {
    @objc func minusButtonTouchDown() {
        if value > minValue {
            value -= step
            delegate?.stepper(self, didChange: value)
            setCountLabelText(value)
        }
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseOut]
        ) {
            [minusButton] in
            minusButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in }
    }
    
    @objc func minusButtonTouchUp() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseIn]
        ) {
            [minusButton] in
            minusButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in }
    }
    
    @objc func plusButtonTouchDown() {
        if value < maxValue {
            value += step
            delegate?.stepper(self, didChange: value)
            setCountLabelText(value)
        }
    
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseOut]) {
            [plusButton] in
            plusButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in }
    }
    
    @objc func plusButtonTouchUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction) {
            [plusButton] in
            plusButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in }
    }
    
}

extension Stepper {
    private func conifureCountLabel() {
        countLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        countLabel.textAlignment = .center
    
        addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        countLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        setCountLabelText(value)
    }
    
    private func configureUI() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = DesignProperties.cornerRadius
    }
    
    private func configurePlusView() {
        plusButton.setPrimaryStyle(icon: Icons.plus, color: Colors.background, constant: 13)
        plusButton.layer.cornerRadius = DesignProperties.cornerRadius - 2
        
        addSubview(plusButton)
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        plusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
        plusButton.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        plusButton.tintColor = Colors.text
        plusButton.layer.masksToBounds = false
        
        plusButton.addTarget(self, action: #selector(plusButtonTouchUp), for: [.touchUpOutside, .touchCancel, .touchUpInside])
        plusButton.addTarget(self, action: #selector(plusButtonTouchDown), for: .touchDown)
    }
    
    private func configureMinusView() {
        minusButton.setPrimaryStyle(icon: Icons.minus, color: Colors.background, constant: 13)
        minusButton.layer.cornerRadius = DesignProperties.cornerRadius - 2
        
        addSubview(minusButton)
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
        minusButton.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        minusButton.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        minusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true

        minusButton.tintColor = Colors.text
        minusButton.layer.masksToBounds = false
        
        minusButton.addTarget(self, action: #selector(minusButtonTouchUp), for: [.touchUpOutside, .touchCancel, .touchUpInside])
        minusButton.addTarget(self, action: #selector(minusButtonTouchDown), for: .touchDown)
    }
}

extension Stepper {
    private func setCountLabelText(_ value: Double) {
        if withFloatingPart {
            countLabel.text = String(value)
        }
        else {
            countLabel.text = String(Int(value))
        }
    }
}
