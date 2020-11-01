//
//  SecondViewController.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 01.11.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit
class SecondViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private lazy var usernameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userAvatarImageView: UIImageView = {
        let view = UIImageView()
        let image = URL(string: "https://via.placeholder.com/100.png?text=Avatar+Image")
        view.kf.setImage(with: image)
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var repoNameTextField: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.placeholder = " repository name"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var languageNameTextField: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.placeholder = " language"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .systemBlue
        view.tintColor = .white
        view.layer.cornerRadius = 15
        view.setTitle("Search!", for: .normal)
        view.addTarget(self, action: #selector(search), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupConstraints() {
        view.addSubview(userAvatarImageView)
        view.addSubview(repoNameTextField)
        view.addSubview(languageNameTextField)
        view.addSubview(searchButton)
        
        let constraints = [
            userAvatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 100),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 100),
            userAvatarImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            
            repoNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repoNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            repoNameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5),
            repoNameTextField.heightAnchor.constraint(equalToConstant: 25),
            
            languageNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            languageNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            languageNameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5),
            languageNameTextField.heightAnchor.constraint(equalToConstant: 25),
            
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: languageNameTextField.bottomAnchor, constant: 45),
            searchButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func search() {
        networkManager.search(repoName: repoNameTextField.text!, language: languageNameTextField.text!)
    }
    
    
}
