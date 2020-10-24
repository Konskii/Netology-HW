//
//  FilteringViewController.swift
//  MultithreadingCourseWork
//
//  Created by Артём Скрипкин on 07.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FilteringViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - UI Elements
    
    ///Большое изображение
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    ///Collection View
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = self.view.bounds.width / 5
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = size
        layout.estimatedItemSize = CGSize(width: 120, height: 75)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(FiltersCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    //MARK: - Variables
    ///Картинка в низком разрешении
    private var thumbnailImage: UIImage?
    
    ///Массив с фотографиями с фильтрами
    private var filterdPhotos: [UIImage?] = []
    
    //MARK: - Constants
    
    ///Массив с названиями фильтров
    private let filtersNames = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone"]

    private let queue = OperationQueue()
    
    //MARK: - Configuring vc data
    
    var data: UIImage? {
        didSet {
            imageView.image = data
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        filter()
    }
    
    //MARK: - Methods
    
    private func setupConstraints() {
        view.addSubview(imageView)
        view.addSubview(collectionView)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -(view.bounds.height - view.layoutMargins.top - view.layoutMargins.bottom) / 3),
            
            collectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    ///Функция для выставления картинки в низком разрешении для предпросмотра фильтров
    /// - Parameters
    /// - image: thumbnail image(картинка в низком разрешении)
    public func setThumbnail(image: UIImage) {
        self.thumbnailImage = image
    }
    
    ///Функция которая накладывает фильтры из списка на изображение
    private func filter() {
        for (index, filter) in filtersNames.enumerated() {
            filterdPhotos.insert(UIImage(named: "indicator"), at: index)
            let operation = FilterImageOperation(image: thumbnailImage, filterName: filter)
            
            operation.completionBlock = {
                DispatchQueue.main.async { 
                    self.filterdPhotos.remove(at: index)
                    self.filterdPhotos.insert(operation.outputImage, at: index)
                    self.collectionView.reloadData()
                }
            }
            
            queue.addOperation(operation)
        }
    }
    
    //MARK: - CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FiltersCell else { return UICollectionViewCell() }
        if !filterdPhotos.isEmpty {
            cell.data = filtersCellData(image: filterdPhotos[indexPath.row], filterName: filtersNames[indexPath.row])
        }
        return cell
    }
    
    //MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PublishingViewController()
        let operation = FilterImageOperation(image: imageView.image, filterName: filtersNames[indexPath.row])
        operation.completionBlock = {
            DispatchQueue.main.async {
                vc.setImage(image: operation.outputImage)
            }
        }
        queue.addOperation(operation)
        navigationController?.pushViewController(vc, animated: true)
    }
}
