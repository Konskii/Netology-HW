//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 20.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - Inits
    convenience init(_ id: User.Identifier) {
        self.init()
        userID = id
        isCurrent = false
    }
    
    //MARK: - Variables
    
    ///Переменная с информацией и методами постов
    private lazy var posts = DataProviders.shared.postsDataProvider
    
    ///Переменная с информацией и методами пользователей
    private lazy var users = DataProviders.shared.usersDataProvider
    
    ///Пользователь, в нем все данные для хедера
    private var user: User?
    
    ///Массив фото(постов) пользователя
    private var images: [UIImage]?
    
    ///Эта переменная хранит id, и если ее значение не nil, то значит в контроллер передали кастомно пользователя
    private var userID: User.Identifier?
    
    //ID current user'а
    private var currentUserID: User.Identifier?
    
    ///Чтобы данные не обновлялись два раза при создании vc создадим переменную, указывающую - обновило ли первый раз данные при запуске
    private var isUpdated = false
    
    ///Свйоство которое указывает какой пользоваетль должен быть отображен - current или нет
    private var isCurrent = true
    
    //MARK: - UI Elements
    
    ///CollectionView с которым мы будем работать
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = self.view.bounds.width / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize.height = 86
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        view.dataSource = self
        view.delegate = self
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    ///Блокирующее вью, которое появляется при долгой работе с данными
    private lazy var blockView: BlockView = {
        var view = BlockView()
        return view
    }()

    
    //MARK: - Methods
    
    ///Установка констрейнтов
    private func setupLayout() {
        guard let tb = tabBarController else { fatalError("Not embbed with tabBarController") }
        view.addSubview(collectionView)
        tb.view.addSubview(blockView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blockView.topAnchor.constraint(equalTo: tb.view.topAnchor),
            blockView.leadingAnchor.constraint(equalTo: tb.view.leadingAnchor),
            blockView.trailingAnchor.constraint(equalTo: tb.view.trailingAnchor),
            blockView.bottomAnchor.constraint(equalTo: tb.view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    ///Функция получающая пользователя асинхронно. После получения обновляет данные
    private func getData() {
        blockView.show()
        if let customUserID = userID {
            users.user(with: customUserID, queue: DispatchQueue.global()) { [weak self] (user) in
                guard let self = self else { return }
                guard let customUser = user else {  Alert.showBasic(vc: self); return }
                
                self.getUserPosts(id: customUser.id)
                self.isUpdated = true
                self.user = customUser
                
                DispatchQueue.main.async {
                    self.title = customUser.username
                    self.collectionView.reloadData()
                    self.blockView.hide()
                }
            }
        } else {
            users.currentUser(queue: DispatchQueue.global()) { [weak self] (user) in
                guard let self = self else { return }
                guard let currentUser = user else {  Alert.showBasic(vc: self); return  }
                
                self.getUserPosts(id: currentUser.id)
                self.isUpdated = true
                self.user = currentUser
                
                DispatchQueue.main.async {
                    self.title = currentUser.username
                    self.collectionView.reloadData()
                    self.blockView.hide()
                }
            }
        }
    }
    
    ///Функция получающая посты(фото) пользователя аснихронно. После выполнения обновляет данные
    /// - Parameters
    /// - id: id пользователя посты которого нужно получить и доабваить в массив с ними
    func getUserPosts(id: User.Identifier) {
        posts.findPosts(by: id, queue: DispatchQueue.global()) { [weak self] (posts) in
            guard let self = self else { return }
            guard let unwrappedPosts = posts else {  Alert.showBasic(vc: self); return  }
            self.images = unwrappedPosts.map({$0.image})
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    ///Функция присваивающая значение переменной currentUserID
    private func getCurrentUserId() {
        if isCurrent {
            users.currentUser(queue: DispatchQueue.global()) { [weak self] (user) in
                guard let self = self else { return }
                guard let currentUser = user else {  Alert.showBasic(vc: self); return  }
                self.currentUserID = currentUser.id
            }
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        getCurrentUserId()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isUpdated {
            getData()
        }
    }
    
    //MARK: - CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let unwrappedImages = images else { return 1 }
        return unwrappedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCell else { fatalError("Not ProfileCell") }
        guard let unwrappedImages = images else { return cell }
        cell.data = unwrappedImages[indexPath.row]
        return cell
    }
    
    //MARK: - Working with supplementary view(header)
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileHeader else { return UICollectionReusableView() }
            view.headerProtocol = self
            view.data = user
            view.isCurrent = isCurrent
            return view
        default:
            fatalError("Not Header")
        }
    }
}

extension ProfileViewController: headerProtocol {
    func follow(id: User.Identifier) {
        users.follow(id, queue: DispatchQueue.global()) { [weak self] (user) in
            guard let self = self else { return }
            guard user != nil else {  Alert.showBasic(vc: self); return  }
            DispatchQueue.main.async {
                self.getData()
            }
        }
    }
    
    func unfollow(id: User.Identifier) {
        users.unfollow(id, queue: DispatchQueue.global()) { [weak self] (user) in
            guard let self = self else { return }
            guard user != nil else {  Alert.showBasic(vc: self); return  }
            DispatchQueue.main.async {
                self.getData()
            }
        }
    }
    
    func reload(index: IndexPath) {
    }
    
    func showVC(data: dataToShowVC?, post: Post.Identifier?) {
        blockView.show()
        guard let info = data else { return }
        let vc = UsersListTableView()
        navigationController?.pushViewController(vc, animated: true)
        
        switch info.followersOrNot {
        case true:
            users.usersFollowingUser(with: info.user.id, queue: DispatchQueue.global()) { [weak self] (users) in
                guard let self = self else { return }
                guard let followers = users else {  Alert.showBasic(vc: self); return  }
                vc.usersArray = followers
                
                DispatchQueue.main.async {
                    vc.reloadData()
                    self.blockView.hide()
                }
            }
        case false:
            users.usersFollowedByUser(with: info.user.id, queue: DispatchQueue.global()) { [weak self] (users) in
                guard let self = self else { return }
                guard let following = users else {  Alert.showBasic(vc: self); return  }
                vc.usersArray = following
                
                DispatchQueue.main.async {
                    vc.reloadData()
                    self.blockView.hide()
                }
            }
        }
    }
}
