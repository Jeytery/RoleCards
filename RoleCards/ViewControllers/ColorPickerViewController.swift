//
//  ColorPickerViewController.swift
//  RoleCards
//
//  Created by Jeytery on 05.10.2021.
//

import UIKit
import Pikko

class ColorPickerViewController: UIViewController {
    
    var didChooseColor: ((UIColor) -> Void)?
    
    let confirmButton = UIButton()
    
    private let pikko = Pikko(dimension: 300, setToColor: .red)
        
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Colors.background
        configurePikko()
        configureConfirmButton()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ColorPickerViewController {
    private func configurePikko() {
        pikko.center = view.center
        view.addSubview(pikko)
    }
    
    private func configureConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.setBottomConstraint(self, constant: -20)
        confirmButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        confirmButton.setPrimaryStyle(icon: Icons.tick, color: Colors.primary)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchDown)
    }
        
    @objc func confirmButtonAction() {
        navigationController?.popViewController(animated: true)
        didChooseColor?(pikko.getColor())
    }
}
