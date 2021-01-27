//
//  Paths.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 26.01.2021.
//

import Foundation
enum AuthentificationPaths {
    static let signin = "/signin"
    static let signout = "/signout"
}

enum UsersPaths {
    static let users = "/users"
    static let currnetUser = "/users/me"
    static let follow = "/users/follow"
    static let unfollow = "/users/unfollow"
    static let followers = "/followers"
    static let following = "/following"
    static let posts = "/posts"
}

enum PostsPaths {
    static let feed = "/posts/feed"
    static let post = "/posts"
    static let like = "/posts/like"
    static let unlike = "/posts/unlike"
    static let likes = "/likes"
    static let create = "/posts/create"
}
