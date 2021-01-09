//
//  GitSearchResponse.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 30.11.2020.
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
