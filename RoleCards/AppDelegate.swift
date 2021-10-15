//
//  AppDelegate.swift
//  RoleCards
//
//  Created by Jeytery on 15.09.2021.
//

import UIKit
import Firebase
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.beginBackgroundTask(expirationHandler: {})
    }
}

// due new sdk glitch i can't make large title in ViewController, idk why
class BigTitleNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
        }
    }
}

class BaseNavigationController: UINavigationController {

    @objc func action() {
        dismiss(animated: true, completion: nil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        let doneButton = UIBarButtonItem(image: Icons.cross,
                                         style: .plain,
                                         target: self,
                                         action: #selector(action))
        topViewController?.navigationItem.rightBarButtonItem = doneButton
        doneButton.tintColor = .gray
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

