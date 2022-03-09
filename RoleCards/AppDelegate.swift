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


