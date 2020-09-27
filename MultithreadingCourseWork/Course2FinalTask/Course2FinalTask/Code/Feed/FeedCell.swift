//
//  FeedCell.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 19.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedCell: UICollectionViewCell {
    //MARK: - Delegates
    
    var indexPath: IndexPath?
    
    weak var cellDelegate: cellPrototol?
    
    //MARK: - UI Elements
    
    ///Изображение поста
    private lazy var postImageView: UIImageView = {
        let view = UIImageView()
        let gs = UITapGestureRecognizer(target: self, action: #selector(postImageTapped))
        gs.numberOfTapsRequired = 2
        
        view.adjustsImageSizeForAccessibilityContentSizeCategory = true
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gs)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    ///Аватар автора поста
    private lazy var authorImageView: UIImageView = {
        let view = UIImageView()
        let gs = UITapGestureRecognizer(target: self, action: #selector(authorAvatarTapped))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gs)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    ///Имя автора поста
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Текст и информацией о времени публикации поста
    private lazy var publishedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Текст с количеством лайков на публикации
    private lazy var likesCountLabel: UILabel = {
        let label = UILabel()
        let gs = UITapGestureRecognizer(target: self, action: #selector(likesLabelTapped))
        
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gs)
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    ///Кнопка лайка под изображением поста
    private lazy var smallLikeButton: UIButton = {
        let button = UIButton()
        let gs = UITapGestureRecognizer(target: self, action: #selector(smallLikeButtonTapped))
        
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(gs)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    ///Текст под постом
    private lazy var postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.tintColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Вьюха с изображением большого лайка
    private lazy var likeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "bigLike"))
        view.layer.opacity = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    //MARK: - Configuring cell
    
    ///Пост, который должен отобразиться
    var data: Post? {
        didSet {
            let df = DateFormatter()
            df.timeStyle = .medium
            df.dateStyle = .medium
            
//            print("IndexPath: \(indexPath!.row)")
//            print("PostId: \(data!.id.rawValue)")
            
            postImageView.image = data?.image
            authorImageView.image = data?.authorAvatar
            authorNameLabel.text = data?.authorUsername
            publishedTimeLabel.text = df.string(from: data!.createdTime)
            likesCountLabel.text = "Likes: \(data!.likedByCount)"
            postDescriptionLabel.text = data?.description
            
            if data!.currentUserLikesThisPost {
                smallLikeButton.tintColor = .blue
            } else {
                smallLikeButton.tintColor = .lightGray
            }
        }
    }
    
    //MARK: - User Interaction
    ///функция которая вызывается при двойном тапе на картинку поста
    @objc func postImageTapped() {
        guard let id = data?.id else { fatalError("ERROR 2") }
        guard let index = indexPath else { fatalError("ERROR 2") }
        DispatchQueue.main.async {
            self.playAnimation()
            self.cellDelegate?.like(postIdTolike: id)
            self.cellDelegate?.reload(index: index)
        }
    }
    ///функция которая вызывается при нажатии на кнопку лайка
    @objc func smallLikeButtonTapped() {
        guard let id = data?.id else { fatalError("ERROR 2") }
        cellDelegate?.likeDislike(postId: id)
    }
    ///функция которая вызывается при нажатии на лейбл с количеством лайков
    @objc func likesLabelTapped() {
        cellDelegate?.showVC(data: nil, post: data?.id)
    }
    ///функция которая вызывается при нажатии на аватар пользователя
    @objc func authorAvatarTapped() {
        guard let id = data?.author else { fatalError("ERROR 2") }
        cellDelegate?.showUser(authorID: id)
    }
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        contentView.addSubview(authorImageView)
        contentView.addSubview(postImageView)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(publishedTimeLabel)
        contentView.addSubview(smallLikeButton)
        contentView.addSubview(likesCountLabel)
        contentView.addSubview(postDescriptionLabel)
        contentView.addSubview(likeImageView)
        
        let constraints = [
            authorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorImageView.heightAnchor.constraint(equalToConstant: 35),
            authorImageView.widthAnchor.constraint(equalToConstant: 35),
            
            postImageView.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            postImageView.heightAnchor.constraint(equalToConstant: 414),
            postImageView.widthAnchor.constraint(equalToConstant: 414),
            
            authorNameLabel.topAnchor.constraint(equalTo: authorImageView.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8),
            
            publishedTimeLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            publishedTimeLabel.bottomAnchor.constraint(equalTo: authorImageView.bottomAnchor),
            
            smallLikeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 0),
            smallLikeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            smallLikeButton.heightAnchor.constraint(equalToConstant: 44),
            smallLikeButton.widthAnchor.constraint(equalToConstant: 44),
            
            likesCountLabel.centerYAnchor.constraint(equalTo: smallLikeButton.centerYAnchor),
            likesCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            postDescriptionLabel.topAnchor.constraint(equalTo: smallLikeButton.bottomAnchor, constant: 0),
            postDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            postDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            likeImageView.centerYAnchor.constraint(equalTo: postImageView.centerYAnchor),
            likeImageView.centerXAnchor.constraint(equalTo: postImageView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension FeedCell {
    func playAnimation() {
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.duration = 0.6
        animation.values = [1, 1, 0]
        animation.keyTimes = [0.1, 0.3, 0.6]
        animation.timingFunctions = [.init(name: .linear), .init(name: .linear), .init(name: .easeOut)]
        likeImageView.layer.add(animation, forKey: "showHide")
    }
}

