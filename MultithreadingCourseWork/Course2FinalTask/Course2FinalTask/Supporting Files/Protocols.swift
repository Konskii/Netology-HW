//
//  Protocols.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 19.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import DataProvider
///Протокол, который используется для оповещения контроллера о том, что нужно поставить лайк посту и обновить данные в ячейке
protocol likeProtocol: class {
    /// - Parameters:
    ///   - postIdTolike: id поста на которой нужно поставить лайк
    func like(postIdTolike id: Post.Identifier)
}

///Протокол, который используется для оповещения контроллера о том, что нужно либо лайкнуть пост, либо дизлайкнуть и обновить данные в ячейке
protocol likeDislikeProtocol: class {
    func likeDislike(postId id: Post.Identifier)
}

///Протокол, который используется для оповещения контроллера о том, что нужно показать user'а, по аватарке которого нажал пользователь
protocol userProtocol: class {
    func showUser(authorID: User.Identifier)
}

///Протокол, который используется для оповещения контроллера о том, что нужно отобразить новый контроллер со списком пользователей
protocol usersProtocol: class {
    ///data передается в случае когда нужно показать подписчиков\подписки,
    ///post передается когда нужно показать список лайков
    /// - Parameters
    ///  - data: экземпляр с данными типа dataToShowVC
    ///  - post: id поста
    func showVC(data: dataToShowVC?, post: Post.Identifier?)
}

///Протокол, который используется для перезагрузки ячейки в ленте
protocol reloadingProtocol: class {
    func reload(index: IndexPath)
}

protocol followProtocol {
    /// - Parameters
    /// - id: id пользователя на которого должен подписаться current
    func follow(id: User.Identifier)
}

protocol unfollowProtocol {
    /// - Parameters
    /// - id: id пользователя от которого должен отписаться current
    func unfollow(id: User.Identifier)
}

protocol cellPrototol: likeProtocol, likeDislikeProtocol, userProtocol, usersProtocol, reloadingProtocol { }
protocol headerProtocol: followProtocol, unfollowProtocol, usersProtocol, reloadingProtocol { }


struct dataToShowVC {
    var user: User
    var followersOrNot: Bool
    init(user: User, followersOrNot: Bool) {
        self.user = user
        self.followersOrNot = followersOrNot
    }
}


