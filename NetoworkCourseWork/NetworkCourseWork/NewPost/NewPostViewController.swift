//
//  NewPostViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import UIKit

class ChoosingPhotoForNewPostViewController: UIViewController {
    
    private var images: [UIImage?] = [UIImage(named: "new1"), UIImage(named: "new2"), UIImage(named: "new3"), UIImage(named: "new4"), UIImage(named: "new5"), UIImage(named: "new6"), UIImage(named: "new7"), UIImage(named: "new8")]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = self.view.bounds.width / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.register(ImageCollectionViewCell.self,
                      forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .white
        navigationItem.title = "Choose photo"
    }
}

extension ChoosingPhotoForNewPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ImageCollectionViewCell else { fatalError() }
        guard let image = images.getElement(at: indexPath.item) else { return cell }
        cell.data = image
        return cell
    }
}

extension ChoosingPhotoForNewPostViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = images.getElement(at: indexPath.item) else { return }
        let vc = ChoosingFilterViewController(image: image)
        navigationController?.pushViewController(vc, animated: true)
    }
}
