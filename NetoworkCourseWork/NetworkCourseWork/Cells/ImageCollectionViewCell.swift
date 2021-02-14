//
//  ImageCollectionViewCell.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 29.01.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    static let reuseIdentifier = "ImageCollectionViewCell"
    
    var data: UIImage? {
        didSet {
            imageView.image = data
        }
    }
    
    //MARK: - UI Elemetns
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: self.contentView.frame)
        return view
    }()
}
