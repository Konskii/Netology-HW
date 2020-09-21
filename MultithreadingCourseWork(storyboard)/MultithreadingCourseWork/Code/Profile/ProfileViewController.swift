//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 13.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider
let cellReuseIdentifier = "photoCell"
let headerReuseIdentifier = "profileHeader"
final class ProfileViewController: UIViewController {
    //MARK:- Variables
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [UIImage]()
    private var userID = DataProviders.shared.usersDataProvider.currentUser().id
    var user: User { DataProviders.shared.usersDataProvider.user(with: userID)! }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = user.username
        
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(UINib(nibName: "ProfileHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        setupLayout()
        getPhotos(userID)
    }
    
    //MARK: - Making Controller Reusable
    convenience init(userID: User.Identifier) {
        self.init()
        self.userID = userID
    }
    
    func changeUserID(idToChange: User.Identifier) {
        userID = idToChange
    }
    
    //MARK:- Methods
    func getPhotos(_ id: User.Identifier) {
        guard let photos = DataProviders.shared.postsDataProvider.findPosts(by: id)?.compactMap({$0.image}) else { return }
        self.photos = photos
    }
    
    func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width / 3, height: view.bounds.width / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.headerReferenceSize.height = 86
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    //MARK:- Configuring Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let cell = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? ProfileHeaderReusableView else { fatalError("ERROR 2") }
            cell.configureHeader(user: user)
            cell.changeID(idToChange: userID)
            cell.followersDelegate = self
            cell.followingDelegate = self
            return cell
        default:
            fatalError("ERROR 6")
        }
    }
}

extension ProfileViewController: showFollowersDelegate, showFollowingDelegate {
    func showFollowers(userID: User.Identifier) {
        guard let users = DataProviders.shared.usersDataProvider.usersFollowingUser(with: userID) else { return }
        let vc = UserListTableViewController(usersArray: users)
        vc.navigationItem.title = "Followers"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showFollowing(userID: User.Identifier) {
        guard let users = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: userID) else { return }
        let vc = UserListTableViewController(usersArray: users)
        vc.navigationItem.title = "Following"
        navigationController?.pushViewController(vc, animated: true)
    }
}
