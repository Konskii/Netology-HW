//
//  FilteringViewController.swift
//  MultithreadingCourseWork
//
//  Created by Артём Скрипкин on 07.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FilteringViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = self.view.bounds.width / 5
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = size
        layout.minimumInteritemSpacing = size
        layout.itemSize = CGSize(width: size, height: size)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var thumbnailImage: UIImage?
    
    private let filtersNames = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone"]
    
    private var filterdPhotos: [UIImage?] = []
    
    private let queue = OperationQueue()
    
    var data: UIImage? {
        didSet {
            imageView.image = data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        filter()
    }
    
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
    
    public func setThumbnail(image: UIImage) {
        self.thumbnailImage = image
    }
    
    private func filter() {
        for (index, filter) in filtersNames.enumerated() {
            filterdPhotos.insert(UIImage(named: "indicator"), at:   index)
            let operation = FilterImageOperation(image: thumbnailImage, filterName: filter)
            
            operation.completionBlock = {
                DispatchQueue.main.async {
                    self.filterdPhotos.remove(at: index)
                    self.filterdPhotos.insert(operation.outputImage, at: index)
                    print("added image")
                    self.collectionView.reloadData()
                }
            }
            
            queue.addOperation(operation)
        }
    }
    
}
extension FilteringViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        if !filterdPhotos.isEmpty {
            cell.data = filterdPhotos[indexPath.row]
        }
        return cell
    }


}
