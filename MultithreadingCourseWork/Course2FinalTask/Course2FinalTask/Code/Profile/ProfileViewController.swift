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
    
    
    ///CollectionView с которым мы будем работать
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = self.view.bounds.width / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize.height = 86
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            blockView.topAnchor.constraint(equalTo: tb.view.topAnchor),
            blockView.leadingAnchor.constraint(equalTo: tb.view.leadingAnchor),
            blockView.trailingAnchor.constraint(equalTo: tb.view.trailingAnchor),
            blockView.bottomAnchor.constraint(equalTo: tb.view.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    ///Функция получающая пользователя асинхронно. После получения обновляет экран
    private func getData() {
        blockView.show()
        if let customUserID = userID {
            users.user(with: customUserID, queue: DispatchQueue.global()) { (user) in
                guard let customUser = user else { fatalError("Custom user doesn't exist") }
                
                self.getUserPosts(id: customUser.id)
                self.isUpdated = true
                self.user = customUser
                
                DispatchQueue.main.async {
                    self.title = customUser.username
                    self.collectionView.reloadData()
                    self.blockView.hide()
                }
                print("customData added")
            }
        } else {
            users.currentUser(queue: DispatchQueue.global()) { (user) in
                guard let currentUser = user else { fatalError("Current user doesn't exist") }
                
                self.getUserPosts(id: currentUser.id)
                self.isUpdated = true
                self.user = currentUser
                
                DispatchQueue.main.async {
                    self.title = currentUser.username
                    self.collectionView.reloadData()
                    self.blockView.hide()
                }
                print("currentData added")
            }
        }
    }
    
    func getUserPosts(id: User.Identifier) {
        posts.findPosts(by: id, queue: DispatchQueue.global()) { (posts) in
            guard let unwrappedPosts = posts else { fatalError("error while getting posts") }
            self.images = unwrappedPosts.map({$0.image})
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    ///Функция присваивающая значение переменной currentUserID
    private func getCurrentUserId() {
        if isCurrent {
            users.currentUser(queue: DispatchQueue.global()) { (user) in
                guard let currentUser = user else { fatalError("Current user doesn't exist") }
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileCell else { fatalError("Not ProfileCell") }
        
        return cell
    }
    
    //MARK: - Working with supplementary view(header)
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileHeader else { return UICollectionReusableView() }
            
            view.data = user
            return view
        default:
            fatalError("Not Header")
        }
    }
}
