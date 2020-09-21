//
//  UserListCell.swift
//  Course2FinalTask
//
//  Created by Артём Скрипкин on 14.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

final class UsersListCell: UITableViewCell {
    override func awakeFromNib() {
        imageView?.contentMode = .scaleAspectFit
    }
    
    func configureCell(user: User) {
        imageView?.image = user.avatar
        textLabel?.text = user.fullName
    }
}
