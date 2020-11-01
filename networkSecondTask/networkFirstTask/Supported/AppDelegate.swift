//
//  AppDelegate.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 24.10.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationController()
        return true
    }
    
}


