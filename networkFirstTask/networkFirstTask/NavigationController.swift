//
//  NavigationController.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 24.10.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit
class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers.append(ViewController())
    }
}
