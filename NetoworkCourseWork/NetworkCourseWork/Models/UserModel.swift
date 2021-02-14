//
//  UserModel.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import Foundation

struct User: Codable {
    var id, username, fullName: String
    var currentUserFollowsThisUser, currentUserIsFollowedByThisUser: Bool
    var followsCount, followedByCount: Int
    var avatar: URL
}
