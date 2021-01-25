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
    //MARK: - Properties
    private let networkManager = NetworkManager()
    
    private let securityManager = SecurityManager()
    
    private var navController: NavigationController?
    
    //MARK: - UI ELements
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
        view.attributedPlaceholder = .init(string: " username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userPassworTextField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = .init(string: " OAuth Token", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        view.textContentType = .password
        view.isSecureTextEntry = true
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
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        guard let navigator = navigationController as? NavigationController else { return }
        navController = navigator
    }
    
    //MARK: - Methods
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
    
    private func authentificate() {
        securityManager.authentificateUser() {[weak self] credentials in
            guard let self = self else { return }
            guard let credentials = credentials else { return }
            DispatchQueue.main.async {
                self.userNameTextField.text = credentials.username
                self.userPassworTextField.text = credentials.password
                self.logInTapped()
            }
        }
    }
    
    //MARK: - UserIneraction Methods
    @objc private func logInTapped() {
        navController?.startAnimating()
        guard let password = userPassworTextField.text else { return }
        guard let account = userNameTextField.text else { return }
        networkManager.getUser(token: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { self.navController?.stopAnimating() }
                Alert.showAlert(viewController: self, type: .error, message: "\(error)")
            case .success(let owner):
                DispatchQueue.main.async {
                    self.navController?.stopAnimating()
                    let vc = SearchRepositoriesViewController(userName: owner.login, userImageUrl: owner.avatarURL)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    //MARK: - Inits
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        authentificate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

