//
//  SearchRepositoriesViewController.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 01.11.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit
class SearchRepositoriesViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.attributedPlaceholder = .init(string: " repository name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var languageNameTextField: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.attributedPlaceholder = .init(string: " language", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
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
        view.addSubview(usernameLabel)
        
        let constraints = [
            userAvatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 100),
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
            searchButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            
            usernameLabel.centerXAnchor.constraint(equalTo: userAvatarImageView.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor, constant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func search() {
        guard let repoName = repoNameTextField.text else { return }
        guard let language = languageNameTextField.text else { return }
        let vc = RepositoriesListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        networkManager.search(repoName: repoName, language: language) {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                Alert.showAlert(viewController: self, type: .error, message: "\(error)")
                self.navigationController?.popViewController(animated: true)
                return
            case .success(let response):
                guard let repos = response.repositories else { return }
                DispatchQueue.main.async {
                    vc.setRepos(repos: repos, count: response.totalCount ?? 00)
                }
            }
        }
    }
    
    convenience init(userName: String, userImageUrl: URL) {
        self.init()
        usernameLabel.text = "Hello, \(userName)"
        userAvatarImageView.kf.setImage(with: userImageUrl)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
