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
    
    ///Чтобы данные не обновлялись два раза при создании vc создадим переменную, указывающую - обновило ли первый раз данные при запуске
    private var isUpdated = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize.height = 530
        layout.itemSize.width = self.view.bounds.width
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        return view
    }()
    
    ///Массив ленты
    private var feedArray: [Post] = []
    
    ///Блокирующее вью, которое появляется при долгой работе с данными
    private lazy var blockView: BlockView = {
        let view = BlockView()
        return view
    }()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        feed(hide: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isUpdated {
            feed(hide: false)
        }
    }
    
    //MARK: - Methods
    
    ///Установка констрейнтов
    private func setupConstraints() {
        guard let unwrappedTabBarController = tabBarController else { fatalError("Not embbed with tabBarController") }
        view.addSubview(collectionView)
        unwrappedTabBarController.view.addSubview(blockView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blockView.topAnchor.constraint(equalTo: unwrappedTabBarController.view.topAnchor),
            blockView.leadingAnchor.constraint(equalTo: unwrappedTabBarController.view.leadingAnchor),
            blockView.trailingAnchor.constraint(equalTo: unwrappedTabBarController.view.trailingAnchor),
            blockView.bottomAnchor.constraint(equalTo: unwrappedTabBarController.view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    ///Функция которая асинхронно получает ленту
    private func feed(hide: Bool) {
        if hide {
            blockView.show()
        }
        posts.feed(queue: DispatchQueue.global(qos: .userInitiated), handler: { [unowned self] (optionalPosts) in
            guard let unwrappedPosts = optionalPosts else { Alert.showBasic(vc: self); return }
            self.isUpdated = true
            DispatchQueue.main.async {
                self.feedArray = unwrappedPosts
                self.collectionView.reloadData()
                self.blockView.hide()
            }
            print("feed loaded successfull")
        })
    }
}

//MARK: - CollectionView Data Source
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
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
        feed(hide: true)
        self.collectionView.reloadItems(at: [index])
    }

    func like(postIdTolike id: Post.Identifier) {
        posts.likePost(with: id, queue: DispatchQueue.global()) { [unowned self] (post) in
            if post != nil {
                print("succes Like to \(String(describing: post?.id))")
            } else {
                 Alert.showBasic(vc: self); return
            }
        }
    }

    func likeDislike(postId id: Post.Identifier) {
        blockView.show()
        posts.post(with: id, queue: DispatchQueue.global()) { [unowned self] (post) in
            guard let unwrappedPost = post else {  Alert.showBasic(vc: self); return  }
            if unwrappedPost.currentUserLikesThisPost {
                self.posts.unlikePost(with: unwrappedPost.id, queue: DispatchQueue.global()) { (post) in
                    if post != nil {
                        print("succes Unlike to \(String(describing: post?.id))")
                        DispatchQueue.main.async {
                            self.feed(hide: false)
                        }
                    } else {
                         self.blockView.hide()
                         Alert.showBasic(vc: self); return
                    }
                }
            } else {
                self.posts.likePost(with: unwrappedPost.id, queue: DispatchQueue.global()) { (post) in
                    if post != nil {
                        print("succes like to \(String(describing: post?.id))")
                        DispatchQueue.main.async {
                            self.feed(hide: false)
                        }
                    } else {
                         self.blockView.hide()
                         Alert.showBasic(vc: self); return
                    }
                }
            }
        }
    }

    func showVC(data: dataToShowVC?, post: Post.Identifier?) {
        guard let postID = post, data == nil else { return }
        posts.usersLikedPost(with: postID, queue: DispatchQueue.global()) { [unowned self] (users) in
            guard let unwrappedUsers = users else {  Alert.showBasic(vc: self); return  }
            DispatchQueue.main.async {
                let vc = UsersListTableView()
                vc.usersArray = unwrappedUsers
                vc.title = "Likes"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func showUser(authorID: User.Identifier) {
        let vc = ProfileViewController(authorID)
        vc.title = "\(authorID.rawValue)"
        navigationController?.pushViewController(vc, animated: true)
    }

}
