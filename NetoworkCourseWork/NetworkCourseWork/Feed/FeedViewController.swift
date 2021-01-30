//
//  FeedViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import UIKit

class FeedViewController: UIViewController {
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
    
    //MARK: - Properties
    private var posts: [Post] = []
    
    //MARK: - Services
    private let networkManager = NetworkManager()
    
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
    
    //MARK: - Methods
}

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

extension FeedViewController {
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
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: "\(error)")
                }
            }
            BlockView.hide()
        }
    }
}

extension FeedViewController: PostCellProtocol {
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
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: "\(error)")
                    
                }
            }
            BlockView.hide()
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
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: "\(error)")
                    
                }
            }
            BlockView.hide()
        }
    }
}
