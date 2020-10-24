//
//  BlockView.swift
//  MultithreadingCourseWork
//
//  Created by Евгений Скрипкин on 04.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
class BlockView: UIView {
    
    let indicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        hide()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureIndicator() {
        indicator.style = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSelf() {
        backgroundColor = .black
        alpha = 0.7
    }
    
    private func setupConstraints() {
        addSubview(indicator)
        
        let constraints = [
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setup() {
        configureSelf()
        configureIndicator()
        setupConstraints()
    }
    
    public func show() {
        indicator.startAnimating()
        isHidden = false
    }
    
    public func hide() {
        indicator.stopAnimating()
        isHidden = true
    }
    
}
