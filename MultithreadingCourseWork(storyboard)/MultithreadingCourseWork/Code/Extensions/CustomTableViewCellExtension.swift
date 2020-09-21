//
//  CustomTableViewCellExtension.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 06.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

extension PostCell {
    //MARK: - Likes methods
    func likePost() {
        //спагетти
        guard likeState == false else { return }
        guard let postID = postIdentifier else { return }
        guard let likesCount = DataProviders.shared.postsDataProvider.post(with: postID).likedByCount else { return }
        guard let isCurrentLikedPost = DataProviders.shared.postsDataProvider.post(with: postID).currentUserLikesThisPost else { return }
        
        likeState = true
        likeButtonOutlet.tintColor = .blue
        
        //спагетти
        if isCurrentLikedPost {
            likes.text = "Likes: \(likesCount)"
        } else {
            likes.text = "Likes: \(likesCount + 1)"
        }
    }
    
    func dislikePost() {
        //спагетти
        guard likeState == true else { return }
        guard let postID = postIdentifier else { return }
        guard let likesCount = DataProviders.shared.postsDataProvider.post(with: postID)?.likedByCount else { return }
        guard let isCurrentLikedPost = DataProviders.shared.postsDataProvider.post(with: postID)?.currentUserLikesThisPost else { return }
        
        likeState = false
        likeButtonOutlet.tintColor = .gray
        
        //спагетти
        if isCurrentLikedPost {
            likes.text = "Likes: \(likesCount - 1)"
        } else {
            likes.text = "Likes: \(likesCount)"
        }
        
        
    }
    
    func showBigLike() {
        let likeImage = UIImage(named: "bigLike")
        let likeView = UIImageView(image: likeImage)
        likeView.center = CGPoint(x: bigImage.center.x, y: bigImage.center.y)
        likeView.layer.opacity = 0
        addSubview(likeView)
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.duration = 0.6
        animation.values = [1, 1, 0]
        animation.keyTimes = [0.1, 0.3, 0.6]
        animation.timingFunctions = [.init(name: .linear), .init(name: .linear), .init(name: .easeOut)]
        animation.isRemovedOnCompletion = true
        likeView.layer.add(animation, forKey: "showAndHideBigLike")
    }
    
    //MARK: - Gestures
    func addGestures() {
        let gs = UITapGestureRecognizer(target: self, action: #selector(bigLike(sender:)))
        gs.numberOfTapsRequired = 2
        bigImage.isUserInteractionEnabled = true
        bigImage.addGestureRecognizer(gs)
        
        let gs2 = UITapGestureRecognizer(target: self, action: #selector(likesButtonPressed(sender:)))
        likes.isUserInteractionEnabled = true
        likes.addGestureRecognizer(gs2)
        
        let gs3 = UITapGestureRecognizer(target: self, action: #selector(authorAvatarPressed(sender:)))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(gs3)
    }
    
    
    //MARK: - Configuring
    func configureCell(_ info: CellData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        if info.post.currentUserLikesThisPost {
            likeButtonOutlet.tintColor = .blue
            likeState = true
        } else {
            likeButtonOutlet.tintColor = .gray
        }
        
        likes.text = "Likes: \(info.post.likedByCount)"
        descriprion.text = info.post.description
        bigImage.image = info.post.image
        avatar.image = info.post.authorAvatar
        name.text = info.post.authorUsername
        date.text = dateFormatter.string(from: info.post.createdTime)
        
        indexPath = info.indexPath
        postIdentifier = info.post.id
        authorID = info.post.author
    }
}

struct CellData {
    
    var indexPath: IndexPath
    
    var post: Post
    
    init(post: Post, indexPath: IndexPath) {
        self.post = post
        self.indexPath = indexPath
    }
    
}
