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
        feed()
    }
    
    var feedArray: [Post] = []
    
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
    
    ///Функция которая асинхронно получает ленту
    func feed() {
        posts.feed(queue: DispatchQueue.global(qos: .userInitiated), handler: {(optionalPosts) in
            guard let unwrappedPosts = optionalPosts else { return }
            self.feedArray = unwrappedPosts
        })
    }
}

//MARK: - Data Source
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var result: Int?
        let queue = DispatchQueue.global()
        
        posts.feed(queue: queue) {(op: [Post]?) -> Void in
            guard let posts = op else { return }
            result = posts.count
        }
        while true {
            if let postsCount = result {
                return postsCount
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedCell else { fatalError("ERROR 1") }
        cell.indexPath = indexPath
        cell.data = feedArray[indexPath.row]
        cell.cellDelegate = self
        return cell
    }
}
//MARK: - Delegates
extension FeedViewController: cellPrototol {
    func reload(index: IndexPath) {
        collectionView.reloadItems(at: [index])
    }

    func like(postIdTolike id: Post.Identifier) {
        _ = posts.likePost(with: id, queue: DispatchQueue.global(qos: .userInteractive)) {(post)  in
            if post != nil {
                print("succes like")
            } else {
                print("unsucces like")
            }
        }
    }

    func likeDislike(postId id: Post.Identifier) {
        posts.post(with: id, queue: DispatchQueue.global(), handler: {(post) in
            guard let unwrappedPost = post else { print("no such post"); return }
            DispatchQueue.main.async {
                if unwrappedPost.currentUserLikesThisPost {
                    _ = self.posts.unlikePost(with: id, queue: DispatchQueue.global()) {(post) in
                        if post != nil {
                            print("succes dislike")
                        } else {
                            print("unsucces dislike")
                        }
                    }
                    self.collectionView.reloadData()
                } else {
                    _ = self.posts.likePost(with: id, queue: DispatchQueue.global(qos: .userInteractive)) {(post)  in
                        if post != nil {
                            print("succes like")
                        } else {
                            print("unsucces like")
                        }
                    }
                    self.collectionView.reloadData()
                }
            }
        })
        
//        guard let post = posts.post(with: id, queue: DispatchQueue.global(), handler: {(post) in}) else { fatalError("ERROR 4")}
    }

    func showVC(data: dataToShowVC?, post: Post.Identifier?) {
        guard let postID = post, data == nil else { return }
        let vc = UsersListTableView()
        var usersArray: [User] = []

//        for id in posts.usersLikedPost(with: postID)! { usersArray.append(users.user(with: id)!) }

        vc.usersArray = usersArray
        vc.title = "Likes"
        navigationController?.pushViewController(vc, animated: true)
    }

    func showUser(authorID: User.Identifier) {
        let vc = ProfileViewController(userIdToShow: authorID)
        navigationController?.pushViewController(vc, animated: true)
    }

}
