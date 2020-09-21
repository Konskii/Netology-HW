//
//  ProfileHeaderReusableView.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 13.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileHeaderReusableView: UICollectionReusableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestures()
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
    }
    //MARK: - Variables
    
    private var userID: User.Identifier = ""
    
    var followersDelegate: showFollowersDelegate?
    
    var followingDelegate: showFollowingDelegate?
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var followersCount: UILabel!
    @IBOutlet private weak var followingCount: UILabel!

    //MARK: - Gestures Actions
    
    @objc func followersPressed() {
        followersDelegate?.showFollowers(userID: userID)
    }
    
    @objc func followingPressed() {
        followingDelegate?.showFollowing(userID: userID)
    }
    
    //MARK: - Methods
    //нарушение инкапсуляции
    func changeID(idToChange: User.Identifier) {
        userID = idToChange
    }
    
    func configureHeader(user: User){
        avatarImage.image = user.avatar
        fullName.text = user.fullName
        followersCount.text = "Followers: \(user.followedByCount)"
        followingCount.text = "Following: \(user.followsCount)"
    }
    
    func addGestures() {
        let gs = UITapGestureRecognizer(target: self, action: #selector(followersPressed))
        followersCount.isUserInteractionEnabled = true
        followersCount.addGestureRecognizer(gs)
        
        let gs2 = UITapGestureRecognizer(target: self, action: #selector(followingPressed))
        followingCount.isUserInteractionEnabled = true
        followingCount.addGestureRecognizer(gs2)
    }
}

//MARK: Delegates
protocol showFollowersDelegate {
    func showFollowers(userID: User.Identifier)
}

protocol showFollowingDelegate {
    func showFollowing(userID: User.Identifier)
}


