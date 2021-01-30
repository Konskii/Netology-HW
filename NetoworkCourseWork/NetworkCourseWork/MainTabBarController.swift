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
        feedVC.tabBarItem.image = UIImage(named: "feed")
        
        let newPostVC = ChoosingPhotoForNewPostViewController()
        let newPostVCNavigation = UINavigationController(rootViewController: newPostVC)
        newPostVC.tabBarItem.title = "New"
        newPostVC.tabBarItem.image = UIImage(named: "plus")
        
        let profileVC = ProfileViewController(userId: nil)
        let profileVCNavigation = UINavigationController(rootViewController: profileVC)
        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.image = UIImage(named: "profile")
        
        viewControllers = [feedVCNavigation, newPostVCNavigation, profileVCNavigation]
    }
    
    static var shared : MainTabBarController {
        return MainTabBarController()
    }
    
    func showFeed() {
        selectedIndex = 0
    }
    
}
