//
//  RepositoriesListViewController.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 02.11.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit

class RepositoriesListViewController: UIViewController {
    
    //MARK: - Properties
    private var repos: [Repository]? {
        didSet {
            tableView.reloadData()
            navController?.stopAnimating()
        }
    }
    
    private var navController: NavigationController?
    
    //MARK: - UI Elements
    private lazy var repoCountLabel: UILabel = {
        let view = UILabel()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.register(RepositoriesListCell.self, forCellReuseIdentifier: RepositoriesListCell.reusedID)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    public func setRepos(repos: [Repository], count: Int) {
        navController?.navigationBar.topItem?.title = "Репозиториев найдено: \(count)"
        self.repos = repos
    }
    
    private func setupConstraints() {
        view.addSubview(repoCountLabel)
        view.addSubview(tableView)
        
        let constraints = [
            repoCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            repoCountLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            repoCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: repoCountLabel.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: repoCountLabel.bottomAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        view.backgroundColor = .white
        guard let navigator = navigationController as? NavigationController else { return }
        navController = navigator
        navController?.startAnimating()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension RepositoriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repos = repos else { return 0 }
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoriesListCell.reusedID, for: indexPath) as? RepositoriesListCell else { return UITableViewCell() }
        guard let repos = repos else { return UITableViewCell() }
        if !repos.isEmpty {
            cell.repoData = repos[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repos = repos else { return }
        guard let url = repos[indexPath.row].url else { return }
        let vc = RepoWebViewController()
        vc.loadRepo(url: url)
        navController?.pushViewController(vc, animated: true)
    }
    
}
