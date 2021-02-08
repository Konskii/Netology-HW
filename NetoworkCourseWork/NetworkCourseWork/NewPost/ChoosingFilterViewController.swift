//
//  ChoosingFilterViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 29.01.2021.
//

import UIKit

class ChoosingFilterViewController: UIViewController {
    
    //MARK: - Init
    convenience init(image: UIImage?) {
        self.init()
        setupConstraints()
        configureNavigationBar()
        view.backgroundColor = .white
        setup(image: image)
    }
    
    //MARK: - Properties
    private let filtersNames = ["CIPhotoEffectChrome",
                                "CIPhotoEffectFade",
                                "CIPhotoEffectNoir",
                                "CIPhotoEffectProcess",
                                "CIPhotoEffectTonal",
                                "CIPhotoEffectTransfer",
                                "CISepiaTone"]
    
    ///Изображение в уменьшенном размере
    private var thumbnailImage: UIImage?
    
    ///Оригинал изображения
    private var fullIMage: UIImage? {
        didSet {
            imageView.image = fullIMage
        }
    }
    
    ///Отфильтрованные уменьшенные изображения
    private var filteredImages: [UIImage?] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    ///Выбранный индекс
    private var selected: IndexPath?
    
    ///queue в которую добавляются операции по фильтрам
    private let queue = OperationQueue()
    
    //MARK: - UI Elemetns
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
    
    //MARK: - Private methods
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
    
    //MARK: - Private objc methods
    @objc private func nextTapped() {
        let vc = CreateNewPostViewController(image: imageView.image)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
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
        cell.data = (filteredImage, filterName)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
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
