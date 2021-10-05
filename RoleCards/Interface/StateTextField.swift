//
//  StateTextField.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit

class StateTextField: UITextField {
    
    var didTap: (() -> Void)?
    
    var didEnter: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        delegate = self
        setStandsrtStyle()
        addTarget(self, action: #selector(didEnterValue), for: .editingChanged)
    }
    
    @objc func didEnterValue(_ sender: UITextField) { didEnter?() }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func popState() {
        setStandsrtStyle()
    }
}

//MARK: - public
extension StateTextField {
    func setErrorState() {
        layer.masksToBounds = true
        backgroundColor = Colors.interface
        textColor = Colors.red
        borderStyle = .roundedRect
        layer.cornerRadius = DesignProperties.cornerRadius
        clearButtonMode = .whileEditing
        layer.borderWidth = 2.5
        layer.borderColor = Colors.red.cgColor
    }
    
    func setSuccessState() {
        layer.masksToBounds = true
        let lightGrey = Colors.interface
        backgroundColor = lightGrey
        textColor = Colors.green
        borderStyle = .roundedRect
        layer.cornerRadius = DesignProperties.cornerRadius
        clearButtonMode = .whileEditing
        layer.borderWidth = 2.5
        layer.borderColor = Colors.green.cgColor
    }
}

//MARK: - [d] TextField
extension StateTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        popState()
        didTap?()
    }
    
    
}
