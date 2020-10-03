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
    func showVC(data: dataToShowVC?, post: Post.Identifier?)
}

///Протокол, который используется для перезагрузки ячейки в ленте
protocol reloadingProtocol: class {
    func reload(index: IndexPath)
}

protocol cellPrototol: likeProtocol, likeDislikeProtocol, userProtocol, usersProtocol, reloadingProtocol { }


struct dataToShowVC {
    var user: User
    var followersOrNot: Bool
    init(user: User, followersOrNot: Bool) {
        self.user = user
        self.followersOrNot = followersOrNot
    }
}


