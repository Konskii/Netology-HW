//
//  Alert.swift
//  MultithreadingCourseWork
//
//  Created by Евгений Скрипкин on 06.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class Alert: UIAlertController {
    /// - Parameters
    /// - vc: vc с которого он будет показываться(обычно self)
    class func showBasic(vc: UIViewController) {
        let alert = UIAlertController(title: "Unknown error!", message: "Please, try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
