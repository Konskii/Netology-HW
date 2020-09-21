//
//  ProfileDataSource.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 13.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? ProfileCollectionViewCell else { fatalError("ERROR 1") }
        cell.config(image: photos[indexPath.item])
        return cell
    }
}
