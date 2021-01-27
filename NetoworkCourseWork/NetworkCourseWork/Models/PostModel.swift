//
//  PostModel.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import Foundation

struct Post: Decodable {
    var id, description, author, authorUserName, createdTime: String
    var image, authorAvatar: URL
    var likedByCount: Int
}
