//
//  BlockView.swift
//  MultithreadingCourseWork
//
//  Created by Евгений Скрипкин on 04.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
class BlockView: UIView {
    //Вот это - сюда
//    private lazy var blockView: UIView = {
//        let parentView = UIView()
//        let indicator = UIActivityIndicatorView()
//
//        indicator.frame = parentView.frame
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        parentView.backgroundColor = .black
//        parentView.alpha = 0.7
//
//        parentView.addSubview(indicator)
//        parentView.translatesAutoresizingMaskIntoConstraints = false
//        return parentView
//    }()
    
    let indicator = UIActivityIndicatorView()
    
    func setup() {
        indicator.style = .gray
        indicator.frame = frame
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        
        backgroundColor = .black
        alpha = 0.7
        
        let constraints = [
            indicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicator.leadingAnchor.constraint(equalTo:leadingAnchor),
            indicator.topAnchor.constraint(equalTo: topAnchor),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func show() {
        indicator.startAnimating()
        isHidden = false
    }
    
    func hide() {
        indicator.stopAnimating()
        isHidden = true
    }
    
}
