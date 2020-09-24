//
//  ProfileHeader.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 21.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileHeader: UICollectionReusableView {
    //MARK: - Delegates
    weak var usersDelegate: usersProtocol?
    
    weak var followDelegate: followProtocol?
    
    ///Аватарка пользователя
    private lazy var userAvatarImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .green
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 35
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    ///Имя пользователя
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "userNameLabel"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Подписчики пользователя (кто на него подписан)
    private lazy var userFollowersLabel: UILabel = {
        let label = UILabel()
        let gs = UITapGestureRecognizer(target: self, action: #selector(followersTapped))
        
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gs)
        label.text = "userFollowersLabel"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Подписки пользователя (на кого он сам подписан)
    private lazy var userFollowingLabel: UILabel = {
        let label = UILabel()
        let gs = UITapGestureRecognizer(target: self, action: #selector(followingTapped))
        
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gs)
        label.text = "userFollowingLabel"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var indexPath: IndexPath?

    
    ///Кнопка "Follow\Unfollow"
    private lazy var followAndUnfollowButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        let gs = UITapGestureRecognizer(target: self, action: #selector(followAndUnfollowButtonTapped))
        
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(gs)
        button.backgroundColor = .init(red: 0, green: 150, blue: 255, alpha: 1)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.setTitle("Follow", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var data: User? {
        didSet {
            userAvatarImage.image = data?.avatar
            userNameLabel.text = data?.fullName
            userFollowersLabel.text = "Followers: \(data!.followedByCount)"
            userFollowingLabel.text = "Following: \(data!.followsCount)"
            if data!.currentUserFollowsThisUser {
                followAndUnfollowButton.setTitle("Unfollow", for: .normal)
            }
        }
    }
    
    //MARK: - User interaction
    
    @objc func followersTapped() {
        guard let user = data else { fatalError("User isn't set") }
        let data = dataToShowVC(user: user, followersOrNot: true)
        usersDelegate?.showVC(data: data, post: nil)
    }
    
    @objc func followingTapped() {
        guard let user = data else { fatalError("User isn't set") }
        let data = dataToShowVC(user: user, followersOrNot: false)
        usersDelegate?.showVC(data: data, post: nil)
    }
    @objc func followAndUnfollowButtonTapped() {
        guard let id = data?.id else { fatalError("User isn't set") }
        followDelegate?.follow(who: id, index: indexPath!)
        reloadInputViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .white
        print("updated")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(userAvatarImage)
        addSubview(userNameLabel)
        addSubview(userFollowersLabel)
        addSubview(userFollowingLabel)
        addSubview(followAndUnfollowButton)
        
        let constraints = [
            userAvatarImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            userAvatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            userAvatarImage.heightAnchor.constraint(equalToConstant: 70),
            userAvatarImage.widthAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.topAnchor.constraint(equalTo: userAvatarImage.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImage.trailingAnchor, constant: 8),
            
            userFollowersLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userFollowersLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            userFollowingLabel.bottomAnchor.constraint(equalTo: userFollowersLabel.bottomAnchor),
            userFollowingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            followAndUnfollowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            followAndUnfollowButton.topAnchor.constraint(equalTo: topAnchor, constant: 6)
//            followAndUnfollowButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
