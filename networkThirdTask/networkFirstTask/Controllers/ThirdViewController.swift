//
//  ThirdViewController.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 02.11.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit
class ThirdViewController: UIViewController {
    
    convenience init(reposToShow: [Repository], count: Int) {
        self.init()
        self.repos = reposToShow
        repoCountLabel.text = "Репозиториев найдено: \(count)"
        repoCountLabel.sizeToFit()
        tableView.reloadData()
    }
    
    private var repos: [Repository]?
    
    private lazy var repoCountLabel: UILabel = {
        let view = UILabel()
        view.contentMode = .scaleToFill
//        view.font = UIFont.boldSystemFont(ofSize: 25)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.register(ThirdViewControllerTableViewCell.self, forCellReuseIdentifier: ThirdViewControllerTableViewCell.reusedID)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        view.backgroundColor = .white
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
}

extension ThirdViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repos = repos else { return 0 }
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThirdViewControllerTableViewCell.reusedID, for: indexPath) as? ThirdViewControllerTableViewCell else { return UITableViewCell() }
        guard let repos = repos else { return UITableViewCell() }
        if !repos.isEmpty {
            cell.repoData = repos[indexPath.row]
        }
        
        return cell
    }
    
}
