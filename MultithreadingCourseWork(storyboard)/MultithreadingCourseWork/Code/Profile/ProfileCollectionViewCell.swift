//
//  ProfileCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 13.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet private weak var imageView: UIImageView!
    
    func config(image: UIImage) {
        imageView.image = image
    }
}
