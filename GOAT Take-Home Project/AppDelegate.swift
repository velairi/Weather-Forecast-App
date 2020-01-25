//
//  AppDelegate.swift
//  GOAT Take-Home Project
//
//  Created by Valerie Don on 1/25/20.
//  Copyright © 2020 Valerie Don. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let homeVC = HomeViewController()
        let vc = UINavigationController(rootViewController: homeVC)
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}

