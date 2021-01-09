//
//  Alert.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 06.01.2021.
//  Copyright © 2021 Артём Скрипкин. All rights reserved.
//

import UIKit
class Alert {
    public enum alertType: String {
        case success = "Успешно"
        case error = "Ошибка"
    }
    class func showAlert(viewController: UIViewController, type: alertType, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: type.rawValue, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            viewController.present(alert, animated: true)
        }
    }
}
