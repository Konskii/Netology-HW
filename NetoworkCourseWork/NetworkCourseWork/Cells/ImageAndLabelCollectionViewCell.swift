//
//  ImageAndLabelCollectionViewCell.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 30.01.2021.
//

import UIKit
class ImageAndLabelCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    static let reuseIdentifier = "ImageAndLabelCollectionViewCell"
    
    var data: (UIImage?, String)? {
        didSet {
            guard let unwrappedData = data else { return }
            imageView.image = unwrappedData.0
            filterNameLabel.text = unwrappedData.1
            layoutIfNeeded()
            sizeToFit()
        }
    }
    
    //MARK: - UI Elements
    ///Картинка
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    ///Label для текста
    private lazy var filterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Public methods
    func highlite() {
        contentView.tintColor = .green
    }
    
    //MARK: - Private methods
    private func setupConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(filterNameLabel)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            filterNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            filterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filterNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            filterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
