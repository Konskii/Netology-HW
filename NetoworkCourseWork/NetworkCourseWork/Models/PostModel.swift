//
//  PostModel.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import Foundation

struct Post: Codable {
    var id, description, author, authorUsername, createdTime: String
    var image, authorAvatar: URL
    var likedByCount: Int
    var currentUserLikesThisPost: Bool
}
