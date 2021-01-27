//
//  AppDelegate.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.bounds = UIScreen.main.bounds
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

