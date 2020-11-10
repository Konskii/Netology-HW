//
//  File.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 03.11.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import Foundation
// MARK: - GitSearchResponse
struct GitSearchResponse: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let repositories: [Repository]?
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case repositories = "items"
    }
}

// MARK: - Repositories
struct Repository: Codable {
    var name: String?
    var description: String?
    var url: String?
    var owner: Owner?

    private enum CodingKeys: String, CodingKey {
        case name, description, owner
        case url = "avatar_url"
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
