//
//  Extension.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func setLargeTitle() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
}

