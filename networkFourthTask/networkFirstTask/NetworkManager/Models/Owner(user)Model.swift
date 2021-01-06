//
//  Owner(user)Model.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 06.01.2021.
//  Copyright © 2021 Артём Скрипкин. All rights reserved.
//

import Foundation
struct Owner: Codable {
    var login: String
    var avatarURL: URL

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
