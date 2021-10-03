//
//  DescTextField.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit

class DescTextFieldView: UIView {
    
    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }
    
    private(set) var textField = StateTextField()
    private let titleLabel = UILabel()
    private let title: String
    
    init(title: String, placeholder: String) {
        self.title = title
        super.init(frame: .zero)
        configureTextField(title: title)
        configureTitleLabel(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - internal funcs
extension DescTextFieldView {
    private func configureTextField(title: String) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.text = title
    }
    
    private func configureTitleLabel(placeholder: String) {
        addSubview(textField)
        textField.setStandsrtStyle()
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.didTap = { [weak self] in self?.popErrorState() }
    }
    
    private func popErrorState() {
        titleLabel.textColor = Colors.text
        titleLabel.text = title
        textField.setStandsrtStyle()
    }
    
    private func setErrorState() {
        titleLabel.textColor = Colors.red
        textField.setErrorState()
    }
}

//MARK: - public
extension DescTextFieldView {
    func setError(text: String) {
        titleLabel.text = text
        setErrorState()
    }
}
