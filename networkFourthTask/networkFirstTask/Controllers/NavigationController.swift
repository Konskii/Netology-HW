//
//  NavigationController.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 24.10.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit
class NavigationController: UINavigationController {
    
    //MARK: - UI Elements
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARKL: - Methods
    public func startAnimating() {
        navigationItem.titleView?.isHidden = true
        navigationBar.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    public func stopAnimating() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        navigationItem.titleView?.isHidden = false
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers.append(LogInViewController())
    }
}
