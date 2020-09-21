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
    //MARK: - Making Controller Reusable
    
    convenience init(userIdToShow: User.Identifier) {
        self.init()
        self.userID = userIdToShow
    }
    
    //MARK: - Variables
    
    private var userID = DataProviders.shared.usersDataProvider.currentUser().id
    private lazy var user: User = { DataProviders.shared.usersDataProvider.user(with: userID)! }()
    private lazy var images: [UIImage] = {
        guard let posts = DataProviders.shared.postsDataProvider.findPosts(by: self.userID) else { fatalError("User '\(user.fullName)' doesn't have posts")}
        return posts.compactMap({$0.image})
    }()
    
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
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username
        setupLayout()
    }
    
    //MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let posts = DataProviders.shared.postsDataProvider.findPosts(by: userID) else { fatalError("User '\(user.fullName)' doesn't have posts") }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileCell else { fatalError("Not ProfileCell") }
        cell.data = images[indexPath.row]
        return cell
    }
    
    //MARK: - Configuring header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileHeader
            view.data = user
            view.usersDelegate = self
            return view
        default:
            fatalError("Not Header")
        }
    }
}

extension ProfileViewController: usersProtocol {
    func showVC(data: dataToShowVC?, post: Post.Identifier?) {
        if let info = data {
            switch info.followersOrNot {
            case true:
                guard let followers = DataProviders.shared.usersDataProvider.usersFollowingUser(with: user.id) else { return }
                let vc = UsersListTableView()
                
                vc.usersArray = followers
                navigationController?.pushViewController(vc, animated: true)
            case false:
                guard let following = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: user.id) else { return }
                let vc = UsersListTableView()
                
                vc.usersArray = following
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
