//
//  ProfileViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    private var user: User? {
        didSet {
            loadPhotos()
        }
    }
    
    private var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        }
    }
    
    private let networkManager = NetworkManager()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = self.view.bounds.width / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize.height = 86
        
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.register(ImageCollectionViewCell.self,
                      forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        view.register(UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: ProfileHeaderCollectionReusableView.reuseIdentifier)
        view.dataSource = self
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        return view
    }()
    
    convenience init(userId: String?) {
        self.init()
        if let userId = userId {
            networkManager.user(userId: userId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    self.showAlert(title: "Error!", message: "\(error)")
                }
            }
        } else {
            networkManager.user() { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    self.showAlert(title: "Error!", message: "\(error)")
                }
            }
        }
    }
    
    private func loadPhotos() {
        guard let userId = user?.id else { return }
        networkManager.posts(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                self.showAlert(title: "Error!", message: "\(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPhotos()
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ImageCollectionViewCell else { fatalError() }
        guard let postImageURL = posts.getElement(at: indexPath.item)?.image else { return cell }
        KingfisherManager.shared.downloader.downloadImage(with: postImageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                cell.data = result.image
            case .failure(let error):
                self.showAlert(title: "Error!", message: "\(error)")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProfileHeaderCollectionReusableView.reuseIdentifier,
                    for: indexPath) as? ProfileHeaderCollectionReusableView else { fatalError() }
            guard let user = user else { return header }
            header.setup(user: user)
            header.delegate = self
            return header
        default:
            fatalError()
        }
    }
}

extension ProfileViewController: ProfileHeaderProtocol {
    func showFollowers() {
        BlockView.show()
        guard let user = user else { return }
        networkManager.followers(userId: user.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let followers):
                DispatchQueue.main.async {
                    let vc = UsersList(users: followers)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                BlockView.hide()
            case .failure(let error):
                BlockView.hide()
                self.showAlert(title: "Error!", message: "\(error)")
            }
        }
    }
    
    func showFollowing() {
        guard let user = user else { return }
        BlockView.show()
        networkManager.following(userId: user.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let following):
                DispatchQueue.main.async {
                    let vc = UsersList(users: following)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                BlockView.hide()
            case .failure(let error):
                BlockView.hide()
                self.showAlert(title: "Error!", message: "\(error)")        
            }
        }
    }
    
    
}
