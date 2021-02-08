//
//  FeedViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    //MARK: - Properties
    private var posts: [Post] = []
    
    private let networkManager = NetworkManager()
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame)
        view.dataSource = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 600
        view.register(UINib(nibName: "PostTableViewCell", bundle: nil),
                      forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)
        view.allowsSelection = false
        return view
    }()
    
    //MARK: - Private methods
    private func updateFeed() {
        BlockView.show()
        networkManager.feed() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.posts = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                BlockView.hide()
            case .failure(let error):
                BlockView.hide()
                self.showAlert(title: "Error!", message: "\(error)")
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFeed()
    }
}

//MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostTableViewCell.reuseIdentifier) as?
                PostTableViewCell else { fatalError() }
        cell.post = posts[indexPath.row]
        cell.layoutIfNeeded()
        cell.delegate = self
        return cell
    }
}

//MARK: - PostCellProtocol
extension FeedViewController: PostCellProtocol {
    func showAuthor(id: String) {
        BlockView.show()
        networkManager.user(userId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    let vc = ProfileViewController(userId: user.id)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                BlockView.hide()
            case .failure(let error):
                BlockView.hide()
                self.showAlert(title: "Error!", message: "\(error)")
            }
        }
    }
    
    func showLikes(id: String) {
        BlockView.show()
        networkManager.likes(postId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let likes):
                DispatchQueue.main.async {
                    let vc = UsersList(users: likes)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                BlockView.hide()
            case .failure(let error):
                BlockView.hide()
                self.showAlert(title: "Error!", message: "\(error)")
            }
        }
    }
    
    func like(id: String) {
        BlockView.show()
        networkManager.like(postIdToLike: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedPost):
                for (index, post) in self.posts.enumerated() {
                    if post.id == id {
                        self.posts.remove(at: index)
                        self.posts.insert(updatedPost, at: index)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                BlockView.hide()
            case .failure(let error):
                BlockView.hide()
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: "\(error)")
                }
            }
        }
    }
    
    func dislike(id: String) {
        BlockView.show()
        networkManager.unlike(postIdToUnlike: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedPost):
                for (index, post) in self.posts.enumerated() {
                    if post.id == id {
                        self.posts.remove(at: index)
                        self.posts.insert(updatedPost, at: index)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    BlockView.hide()
                }
            case .failure(let error):
                BlockView.hide()
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: "\(error)")
                }
            }
        }
    }
}
