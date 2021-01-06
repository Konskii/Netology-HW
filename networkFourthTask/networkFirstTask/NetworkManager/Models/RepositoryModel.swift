//
//  RepositoriesModel.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 30.11.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import Foundation
// MARK: - Repository
struct Repository: Codable {
    var name: String?
    var description: String?
    var url: URL?
    var owner: Owner?
    private enum CodingKeys: String, CodingKey {
        case name, description, owner
        case url = "html_url"
    }

    struct Owner: Codable {
        var login: String
        var avatarURL: String

        private enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }
}
