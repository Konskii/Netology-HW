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
        DispatchQueue.global(qos: .utility).async {
            self.feed()
        }
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
            print("feed loaded successfull")
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
        DispatchQueue.main.async {
            if !self.feedArray.isEmpty {
                cell.data = self.feedArray[indexPath.row]
            } else {
                return
            }
            cell.indexPath = indexPath
            cell.cellDelegate = self
        }
        return cell
    }
}
//MARK: - Delegates
extension FeedViewController: cellPrototol {
    func reload(index: IndexPath) {
        feed()
        self.collectionView.reloadItems(at: [index])
    }

    func like(postIdTolike id: Post.Identifier) {
        posts.likePost(with: id, queue: DispatchQueue.global()) {(post) in
            if post != nil {
                print("succesLike to \(String(describing: post?.id))")
            } else {
                print("no such post with id: \(String(describing: post?.id))")
            }
        }
    }

    func likeDislike(postId id: Post.Identifier) {
        
    }

    func showVC(data: dataToShowVC?, post: Post.Identifier?) {
        
    }

    func showUser(authorID: User.Identifier) {
        
    }

}
