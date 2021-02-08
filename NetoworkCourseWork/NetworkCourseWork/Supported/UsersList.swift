//
//  UsersList.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 30.01.2021.
//

import UIKit
import Kingfisher

class UsersList: UIViewController {
    
    //MARK: - Init
    convenience init(users: [User]) {
        self.init()
        for user in users {
            KingfisherManager.shared.downloader.downloadImage(with: user.avatar) {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.users.append((user, result.image))
                case .failure(_):
                    self.showAlert(title: "Error!", message: ErrorHandler().handleError())
                }
            }
        }
    }
    
    //MARK: - Properties
    private var users: [(User, UIImage?)] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - UI Elemetns
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 44
        view.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        return view
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
}

//MARK: - UITableViewDataSource
extension UsersList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        guard let user = users.getElement(at: indexPath.row) else { return cell }
        if #available(iOS 14, *) {
            var content = cell.defaultContentConfiguration()
            content.image = user.1
            content.text = user.0.fullName
            content.imageProperties.cornerRadius = tableView.rowHeight / 2
            cell.contentConfiguration = content
        } else {
            cell.imageView?.image = user.1
            cell.textLabel?.text = user.0.fullName
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension UsersList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = users.getElement(at: indexPath.row) else { return }
        let vc = ProfileViewController(userId: user.0.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
