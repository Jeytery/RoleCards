//
//  RolePickerViewController.swift
//  RoleCards
//
//  Created by Jeytery on 19.10.2021.
//

import UIKit

protocol RolePickerViewControllerDelegate: AnyObject {
    
}

class RolePickerViewController: UIViewController {
    
    weak var delegate: RolePickerViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension RolePickerViewController {
    
}
