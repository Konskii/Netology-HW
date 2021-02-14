//
//  BlockView.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 27.01.2021.
//

import UIKit

class BlockView: UIView {
    
    static var activityIndicator = UIActivityIndicatorView(frame: UIScreen.main.bounds)
    
    static public func show() {
        DispatchQueue.main.async {
            setup()
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }
    }
    
    static public func hide() {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    private static func setup() {
        guard let window = UIApplication.shared.windows
                .first(where: { $0.isKeyWindow }) else { return }
        
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.7)
        activityIndicator.color = .white
        activityIndicator.style = .white
        activityIndicator.hidesWhenStopped = true
        
        window.addSubview(activityIndicator)
    }

}
