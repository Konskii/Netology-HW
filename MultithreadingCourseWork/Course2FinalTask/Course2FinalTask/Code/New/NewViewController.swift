//
//  NewViewController.swift
//  MultithreadingCourseWork
//
//  Created by Артём Скрипкин on 07.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class NewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - UI Elements
    
    ///CollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = self.view.bounds.width / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
    
    //MARK: - Variables
    
    ///Массив с картинками в высоком разрешении
    private lazy var images: [UIImage] = {
        return DataProviders.shared.photoProvider.photos()
    }()
    
    ///Массив с картинками в низком разрешении
    private lazy var thumbnailIMages: [UIImage] = {
        return DataProviders.shared.photoProvider.thumbnailPhotos()
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        setupConstraints()
    }
    
    //MARK: - Methods
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    //MARK: - CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        cell.data = images[indexPath.row]
        return cell
    }
    
    //MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FilteringViewController()
        vc.data = images[indexPath.row]
        vc.setThumbnail(image: thumbnailIMages[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
