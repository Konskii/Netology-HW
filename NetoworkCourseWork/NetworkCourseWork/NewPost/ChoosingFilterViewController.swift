//
//  ChoosingFilterViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 29.01.2021.
//

import UIKit

class ChoosingFilterViewController: UIViewController {
    
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
        layout.itemSize.width = 180
        layout.itemSize.height = 75
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ImageAndLabelCollectionViewCell.self,
                      forCellWithReuseIdentifier: ImageAndLabelCollectionViewCell.reuseIdentifier)
        view.allowsMultipleSelection = false
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let filtersNames = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone"]
    
    private var thumbnailImage: UIImage?
    
    private var fullIMage: UIImage? {
        didSet {
            imageView.image = fullIMage
        }
    }
    
    private var filteredImages: [UIImage?] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var selected: IndexPath?
    
    private let queue = OperationQueue()
    
    private func setup(image: UIImage?) {
        fullIMage = image
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        thumbnailImage = UIImage(data: imageData)
        filterImage()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Filters"
        navigationItem.rightBarButtonItem = .init(title: "Next",
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(nextTapped))
    }
    
    @objc private func nextTapped() {
        let vc = CreateNewPostViewController(image: imageView.image)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    convenience init(image: UIImage?) {
        self.init()
        setupConstraints()
        configureNavigationBar()
        view.backgroundColor = .white
        setup(image: image)
    }
    
    private func filterImage() {
        for (index, filter) in filtersNames.enumerated() {
            filteredImages.insert(UIImage(named: "indicator"), at: index)
            let operation = FilterImageOperation(image: thumbnailImage, filterName: filter)
            
            operation.completionBlock = {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.filteredImages.remove(at: index)
                    self.filteredImages.insert(operation.outputImage, at: index)
                    self.collectionView.reloadData()
                }
            }
            
            queue.addOperation(operation)
        }
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
    
    private func getFullFilteredImage(filter: String,
                                      completion: @escaping (UIImage?) -> Void) {
        BlockView.show()
        let operation = FilterImageOperation(image: fullIMage, filterName: filter)
        operation.completionBlock = {
            completion(operation.outputImage)
            BlockView.hide()
        }
        queue.addOperation(operation)
    }
}

extension ChoosingFilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageAndLabelCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ImageAndLabelCollectionViewCell else { fatalError() }
        guard let filteredImage = filteredImages.getElement(at: indexPath.item) else { return cell }
        guard let filterName = filtersNames.getElement(at: indexPath.item) else { return cell }
        cell.data = FilteredImage(image: filteredImage, filterName: filterName)
        return cell
    }
}

extension ChoosingFilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let filterName = filtersNames.getElement(at: indexPath.item) else { return }
        getFullFilteredImage(filter: filterName) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        selected = indexPath
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        print("highlited at:\(indexPath.item)")
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
}
