//
//  AutorizationViewController.swift
//  RoleCards
//
//  Created by Jeytery on 30.09.2021.
//

import UIKit

protocol AutorizationViewControllerDelegate: AnyObject {
    func autorizationViewControllerDidAutorized()
}

class AutorizationViewContoller: UIViewController {
    weak var delegate: AutorizationViewControllerDelegate?
}
