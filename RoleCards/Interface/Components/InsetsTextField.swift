//
//  InsetsTextField.swift
//  RoleCards
//
//  Created by Jeytery on 02.03.2022.
//

import UIKit

class InsestsTextField: UITextField {
    let insests: UIEdgeInsets

    init(insests: UIEdgeInsets) {
        self.insests = insests
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insests)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insests)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insests)
    }
}
