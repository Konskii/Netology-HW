//
//  LogInViewController.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 24.10.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit
import Kingfisher

class LogInViewController: UIViewController {
    
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        let image = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png")
        view.kf.setImage(with: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userNameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = " username"
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userPassworTextField: UITextField = {
        let view = UITextField()
        view.placeholder = " password"
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logInButton: UIButton = {
        let view = UIButton(type: .roundedRect)
        view.setTitle("Log In", for: .normal)
        view.backgroundColor = .systemBlue
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        view.addSubview(userNameTextField)
        view.addSubview(userPassworTextField)
        view.addSubview(logInButton)
        view.addSubview(logoImageView)
        
        let constraints = [
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            userNameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5),
            userNameTextField.heightAnchor.constraint(equalToConstant: 25),
            
            userPassworTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            userPassworTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPassworTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5),
            userPassworTextField.heightAnchor.constraint(equalToConstant: 25),

            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.topAnchor.constraint(equalTo: userPassworTextField.bottomAnchor, constant: 45),
            logInButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func logInTapped() {
        navigationController?.pushViewController(SearchRepositoriesViewController(), animated: true)
    }
}

