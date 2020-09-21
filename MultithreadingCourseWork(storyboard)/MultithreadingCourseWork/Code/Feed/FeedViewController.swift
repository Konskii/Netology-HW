//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 06.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

final class FeedViewController: UIViewController {
    private lazy var currentUser: User = {
        return DataProviders.shared.usersDataProvider.currentUser()
    }()
    
    lazy var feed: [Post] = {
        return DataProviders.shared.postsDataProvider.feed()
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.dataSource = self
    }
}

extension FeedViewController: likesPressedProtocol {
    func showLikesVC(postID: Post.Identifier, indexPath: IndexPath, likeState: Bool) {
        guard let usersID = DataProviders.shared.postsDataProvider.usersLikedPost(with: postID) else { return }
        //спагетти
        var users = [User]()
        for id in usersID { users.append(DataProviders.shared.usersDataProvider.user(with: id)!) }
        
        //спагетти
        if likeState == true && users.contains(where: {$0.id == currentUser.id}) == false {
            users.append(currentUser)
        } else if likeState == false && users.contains(where: {$0.id == currentUser.id}) == true {
            for (index, user) in users.enumerated() {
                if user.id == currentUser.id {
                    users.remove(at: index)
                }
            }
        }
        let vc = UserListTableViewController(usersArray: users)
        vc.navigationItem.title = "Likes"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedViewController: profileProtocol {
    func showProfile(authorID: User.Identifier) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
        vc.changeUserID(idToChange: authorID)
        navigationController?.pushViewController(vc, animated: true)
    }
}
