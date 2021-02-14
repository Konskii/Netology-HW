//
//  ProfileHeaderCollectionReusableView.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 30.01.2021.
//

import UIKit
import Kingfisher

protocol ProfileHeaderProtocol: class {
    func showFollowers()
    func showFollowing()
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    //MARK: - Properties
    static let reuseIdentifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderProtocol?
    
    //MARK: - UI Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    //MARK: - Public methods
    public func setup(user: User) {
        fullNameLabel.text = user.fullName
        setFollowers(count: user.followedByCount)
        setFollowing(count: user.followsCount)
        imageView.kf.setImage(with: user.avatar)
        
        let followersTap = UITapGestureRecognizer(target: self,
                                                  action: #selector(followersTapped))
        let followingTap = UITapGestureRecognizer(target: self,
                                                  action: #selector(followingTapped))
        
        followersLabel.addGestureRecognizer(followersTap)
        followingLabel.addGestureRecognizer(followingTap)
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    
    //MARK: - Private methods
    private func setFollowers(count: Int) {
        followersLabel.text = "Followers: \(count)"
    }
    
    private func setFollowing(count: Int) {
        followingLabel.text = "Following: \(count)"
    }
    
    //MARK: - Private objc methods
    @objc private func followersTapped() {
        delegate?.showFollowers()
    }
    
    @objc private func followingTapped() {
        delegate?.showFollowing()
    }
}
