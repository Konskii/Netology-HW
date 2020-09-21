//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 19.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider
let reuseIdentifier = "cell"
class FeedViewController: UIViewController {
    
    //MARK: - Variables
    private lazy var posts = DataProviders.shared.postsDataProvider
    private lazy var users = DataProviders.shared.usersDataProvider
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize.width = self.view.bounds.width
        layout.itemSize.height = 530
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: - Data Source
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.feed().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedCell else { fatalError("ERROR 1") }
        cell.data = posts.feed()[indexPath.row]
        cell.indexPath = indexPath
        cell.likeDelegate = self
        cell.usersDelegate = self
        cell.likeDislikeDelegate = self
        cell.userDelegate = self
        cell.reloadingDelegate = self
        return cell
    }
}
//MARK: - Delegates
extension FeedViewController: likeProtocol, usersProtocol, userProtocol, likeDislikeProtocol, reloadingProtocol {
    func reload(index: IndexPath) {
        collectionView.reloadItems(at: [index])
    }
    
    func like(postIdTolike id: Post.Identifier) {
        _ = posts.likePost(with: id)
    }
    
    func likeDislike(postId id: Post.Identifier) {
        guard let post = posts.post(with: id) else { fatalError("ERROR 4")}
        if post.currentUserLikesThisPost {
            _ = posts.unlikePost(with: id)
            collectionView.reloadData()
        } else {
            _ = posts.likePost(with: id)
            collectionView.reloadData()
        }
    }
    
    func showVC(data: dataToShowVC?, post: Post.Identifier?) {
        guard let postID = post, data == nil else { return }
        let vc = UsersListTableView()
        var usersArray: [User] = []
        
        for id in posts.usersLikedPost(with: postID)! { usersArray.append(users.user(with: id)!) }
        
        vc.usersArray = usersArray
        vc.title = "Likes"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showUser(authorID: User.Identifier) {
        let vc = ProfileViewController(userIdToShow: authorID)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
