//
//  MainTabBarController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let feedVC = FeedViewController()
        let feedVCNavigation = UINavigationController(rootViewController: feedVC)
        feedVC.tabBarItem.title = "Feed"
        
        let newPostVC = NewPostViewController()
        let newPostVCNavigation = UINavigationController(rootViewController: newPostVC)
        newPostVC.tabBarItem.title = "New"
        
        let profileVC = ProfileViewController()
        let profileVCNavigation = UINavigationController(rootViewController: profileVC)
        profileVC.tabBarItem.title = "Profile"
        
        viewControllers = [feedVCNavigation, newPostVCNavigation, profileVCNavigation]
    }
}
