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
    
    var data: User? {
        didSet {
            userAvatarImage.image = data?.avatar
            userNameLabel.text = data?.fullName
            userFollowersLabel.text = "Followers: \(data!.followedByCount)"
            userFollowingLabel.text = "Following: \(data!.followsCount)"
        }
    }
    
    //MARK: - User interaction
    
    @objc func followersTapped() {
        guard let user = data else { fatalError("User isn't set")}
        let data = dataToShowVC(user: user, followersOrNot: true)
        usersDelegate?.showVC(data: data, post: nil)
    }
    
    @objc func followingTapped() {
        guard let user = data else { fatalError("User isn't set")}
        let data = dataToShowVC(user: user, followersOrNot: false)
        usersDelegate?.showVC(data: data, post: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(userAvatarImage)
        addSubview(userNameLabel)
        addSubview(userFollowersLabel)
        addSubview(userFollowingLabel)
        
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
            userFollowingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
