//
//  PostCell.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 02.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


class PostCell: UITableViewCell {
    override func awakeFromNib() {
        addGestures()
        bigImage.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
    //MARK: - Variables
    
    var postIdentifier: Post.Identifier?
    
    var indexPath: IndexPath?
    
    var authorID: User.Identifier?
    
    //MARK: - Delegates
    
    weak var delegate: likesPressedProtocol?
    
    weak var delegateForProfile: profileProtocol?
    
    //MARK: - Outlets

    @IBOutlet weak var likes: UILabel!
    
    @IBOutlet weak var descriprion: UILabel!
    
    @IBOutlet weak var bigImage: UIImageView!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    var likeState = false

    //MARK: - Gestures actions
    
    @IBAction func likeButton(_ sender: UIButton) {
        if likeState == false {
            likePost()
        } else {
            dislikePost()
        }
    }

    @objc func bigLike(sender: UIGestureRecognizer) {
        if likeState == false { likePost() }
        showBigLike()
    }
    
    @objc func likesButtonPressed(sender: UIGestureRecognizer) {
        guard let postId = postIdentifier else { return }
        guard let cellIndexPath = indexPath else { return }
        
        delegate?.showLikesVC(postID: postId, indexPath: cellIndexPath, likeState: likeState)
    }
    
    @objc func authorAvatarPressed(sender: UIGestureRecognizer) {
        guard let id = authorID else { return }
        delegateForProfile?.showProfile(authorID: id)
    }
}
//MARK: - Protocols for delegates

protocol likesPressedProtocol: class {
    func showLikesVC(postID: Post.Identifier, indexPath: IndexPath, likeState: Bool)
}

protocol profileProtocol: class {
    func showProfile(authorID: User.Identifier)
}
