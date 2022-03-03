//
//  Stepper.swift
//  RoleCards
//
//  Created by Jeytery on 03.03.2022.
//

import UIKit
    
class Stepper: UIView {

    struct Style {
        let backgroundColor: UIColor
        
        static let light = Style(backgroundColor: Colors.navigation)
        static let dark = Style(backgroundColor:  Colors.navigation)
    }
    
    private(set) var value: Double = 0
    
    var maxValue: Double = 0
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
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension Stepper {
    private func ImageView(backgroundColor: UIColor, image: UIImage) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return view
    }
    
    private func conifureCountLabel() {
        countLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        if withFloatingPart {
            countLabel.text = String(value)
        }
        else {
            countLabel.text = String(Int(value))
        }
        countLabel.textAlignment = .center
        
        addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        countLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func configureUI() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = DesignProperties.cornerRadius
    }
    
    private func configurePlusView() {
        plusButton.setPrimaryStyle(icon: Icons.plus, color: Colors.background, constant: 13)
        addSubview(plusButton)
        addShadow(_view: plusButton)
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        plusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        plusButton.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        plusButton.tintColor = .black
        plusButton.layer.masksToBounds = false
        
        plusButton.addTarget(self, action: #selector(plusButtonTouchUp), for: [.touchUpOutside, .touchCancel, .touchUpInside])
        plusButton.addTarget(self, action: #selector(plusButtonTouchDown), for: .touchDown)
    }
    
    private func configureMinusView() {
        minusButton.setPrimaryStyle(icon: Icons.minus, color: Colors.background, constant: 13)
        addSubview(minusButton)
        addShadow(_view: minusButton)
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        minusButton.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        minusButton.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        minusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true

        minusButton.tintColor = .black
        minusButton.layer.masksToBounds = false
        
        minusButton.addTarget(self, action: #selector(minusButtonTouchUp), for: [.touchUpOutside, .touchCancel, .touchUpInside])
        minusButton.addTarget(self, action: #selector(minusButtonTouchDown), for: .touchDown)
    }
    
    @objc func minusButtonTouchDown() {
        value -= step
        if withFloatingPart {
            countLabel.text = String(value)
        }
        else {
            countLabel.text = String(Int(value))
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
        value += step
        if withFloatingPart {
            countLabel.text = String(value)
        }
        else {
            countLabel.text = String(Int(value))
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        minusButton.layer.shadowPath = UIBezierPath(rect: minusButton.bounds).cgPath
        plusButton.layer.shadowPath = UIBezierPath(rect: minusButton.bounds).cgPath
    }
    
    private func addShadow(_view: UIView) {
        _view.layer.shadowColor = UIColor.black.cgColor
        _view.layer.shadowOpacity = 0.08
        _view.layer.shadowOffset = .init(width: 3, height: 0)
        _view.layer.shadowRadius = 6
        _view.layer.shouldRasterize = true
    }
}
