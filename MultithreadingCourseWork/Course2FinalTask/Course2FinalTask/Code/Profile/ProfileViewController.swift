//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 20.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - Inits
    convenience init(_ id: User.Identifier) {
        self.init()
        userID = id
    }
    
    //MARK: - Variables
    
    ///Переменная с информацией и методами постов
    private lazy var posts = DataProviders.shared.postsDataProvider
    
    ///Переменная с информацией и методами пользователей
    private lazy var users = DataProviders.shared.usersDataProvider
    
    private var user: User?
    private var images: [UIImage]?
    private var userID: User.Identifier?
    private var currentUserID: User.Identifier?
    
    
    ///CollectionView с которым мы будем работать
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = self.view.bounds.width / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize.height = 86
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        view.dataSource = self
        view.delegate = self
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var blockView: BlockView = {
        var view = BlockView()
        return view
    }()

    
    //MARK: - Methods
    
    private func setupLayout() {
        guard let tb = tabBarController else { fatalError("Not embbed with tabBarController") }
        view.addSubview(collectionView)
        tb.view.addSubview(blockView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            blockView.topAnchor.constraint(equalTo: tb.view.topAnchor),
            blockView.leadingAnchor.constraint(equalTo: tb.view.leadingAnchor),
            blockView.trailingAnchor.constraint(equalTo: tb.view.trailingAnchor),
            blockView.bottomAnchor.constraint(equalTo: tb.view.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    ///Функция получающая пользователя асинхронно. После получения обновляет экран
    private func getData() {
        blockView.show()
        if let customUserID = userID {
            users.user(with: customUserID, queue: DispatchQueue.global()) { (user) in
                guard let customUser = user else { fatalError("Custom user doesn't exist") }
                DispatchQueue.main.async {
                    self.user = customUser
                    self.collectionView.reloadData()
                    self.blockView.hide()
                }
                print("currentData added")
            }
        } else {
            users.currentUser(queue: DispatchQueue.global()) { (user) in
                guard let currentUser = user else { fatalError("Current user doesn't exist") }
                DispatchQueue.main.async {
                    self.user = currentUser
                    self.collectionView.reloadData()
                    self.blockView.hide()
                }
                print("currentData added")
            }
        }
    }
    
    private func getCurrentUserId() {
        users.currentUser(queue: DispatchQueue.global()) { (user) in
            guard let currentUser = user else { fatalError() }
            self.currentUserID = currentUser.id
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUserId()
        setupLayout()
        getData()
    }
    
    //MARK: - CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileCell else { fatalError("Not ProfileCell") }
        
        return cell
    }
    
    //MARK: - Working with supplementary view(header)
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileHeader else { return UICollectionReusableView() }
            if let unwrappedCurrentID = currentUserID, let unwrappedUserID = userID {
                if unwrappedUserID == unwrappedCurrentID {
                    view.isCurrent = true
                } else {
                    view.isCurrent = false
                }
            }
            
            view.data = user
            return view
        default:
            fatalError("Not Header")
        }
    }
}
