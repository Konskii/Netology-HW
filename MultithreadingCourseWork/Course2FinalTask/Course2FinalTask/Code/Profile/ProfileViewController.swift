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
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.adjustsImageSizeForAccessibilityContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    
    func setupLayout() {
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func getData() {
        if let customUserID = userID {
            users.user(with: customUserID, queue: DispatchQueue.global()) { (user) in
                
            }
        } else {
            users.currentUser(queue: DispatchQueue.global()) { (user) in
                guard let currentUser = user else { fatalError("Current user doesn't exist") }
                self.user = currentUser
                print("currentData added")
            }
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            DispatchQueue.main.async {
                while true {
                    if let userData = self.user {
                        view.data = userData
                        print("user added to header")
                        break
                    }
                }
            }
            
            return view
        default:
            fatalError("Not Header")
        }
    }
}
