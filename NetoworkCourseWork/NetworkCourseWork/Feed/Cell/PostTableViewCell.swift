//
//  PostTableViewCell.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 27.01.2021.
//

import UIKit
import Kingfisher

protocol PostCellProtocol: class {
    func like(id: String)
    func dislike(id: String)
    func showAuthor(id: String)
    func showLikes(id: String)
}

class PostTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "PostTableViewCell"
    
    weak var delegate: PostCellProtocol?
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            avatar.kf.setImage(with: post.authorAvatar)
            fullName.text = post.authorUsername
            postImage.kf.setImage(with: post.image)
            setLikes(count: post.likedByCount)
            postDescription.text = post.description
            if post.currentUserLikesThisPost {
                likeButton.tintColor = .systemBlue
            } else {
                likeButton.tintColor = .lightGray
            }
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            guard let date = df.date(from: post.createdTime) else { return }
            df.dateStyle = .medium
            df.timeStyle = .short
            createdTime.text = df.string(from: date)
            
            let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageViewTap.numberOfTapsRequired = 2
            postImage.addGestureRecognizer(imageViewTap)
            
            let likesTap = UITapGestureRecognizer(target: self, action: #selector(likesTapped))
            likesCount.addGestureRecognizer(likesTap)
            
            let userTap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
            //TODO: - Разобраться почему для аватарки нужен отдельный gestureRecognizer
            let anotherUserTap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
            avatar.isUserInteractionEnabled = true
            avatar.addGestureRecognizer(anotherUserTap)
            fullName.addGestureRecognizer(userTap)
            
            postImage.addSubview(bigLike)
            bigLike.centerYAnchor.constraint(equalTo: postImage.centerYAnchor).isActive = true
            bigLike.centerXAnchor.constraint(equalTo: postImage.centerXAnchor).isActive = true
        }
    }

    //MARK: - UI Outlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postDescription: UILabel!
    
    //MARK: - UI Elemetns
    private lazy var bigLike: UIImageView = {
        let view = UIImageView(image: UIImage(named: "bigLike"))
        view.layer.opacity = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Private methods
    private func setLikes(count: Int) {
        likesCount.text = "Likes: \(count)"
    }
    
    private func animateBigLike(completion: @escaping (Bool) -> Void) {
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: .calculationModeLinear, animations: { [weak self] in
            guard let self = self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                self.bigLike.layer.opacity = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2, animations: {
                self.bigLike.layer.opacity = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3, animations: {
                self.bigLike.layer.opacity = 0
            })
        }, completion: completion)
    }
    
    //MARK: - Private objc methods
    @objc private func imageTapped() {
        guard let id = post?.id else { return }
        guard let status = post?.currentUserLikesThisPost, !status else { return }
        animateBigLike() {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.like(id: id)
        }
    }
    
    @objc private func likesTapped() {
        guard let id = post?.id else { return }
        delegate?.showLikes(id: id)
    }
    
    @objc private func userTapped() {
        guard let id = post?.author else { return }
        delegate?.showAuthor(id: id)
    }
    
    @IBAction private func likeTapped() {
        guard let status = post?.currentUserLikesThisPost else { return }
        guard let id = post?.id else { return }
        if status {
            delegate?.dislike(id: id)
        } else {
            animateBigLike(){ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.like(id: id)
            }
        }
    }
}
