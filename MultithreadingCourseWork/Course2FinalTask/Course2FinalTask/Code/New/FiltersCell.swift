//
//  FiltersCell.swift
//  MultithreadingCourseWork
//
//  Created by Артём Скрипкин on 08.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
class FiltersCell: UICollectionViewCell {
    
    //MARK: - UI Elements
    
    ///Отфильтрованная картинка
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    ///Название фильтра
    private lazy var filterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Configuring cell data
    
    var data: filtersCellData? {
        didSet {
            guard let unwrappedData = data else { return }
            imageView.image = unwrappedData.image
            filterNameLabel.text = unwrappedData.filterName
        }
    }
    
    //MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
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
