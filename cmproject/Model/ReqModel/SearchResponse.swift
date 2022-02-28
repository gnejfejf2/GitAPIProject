//
//  SearchRequest.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/23.
//

import Foundation

// MARK: - Welcome
struct SearchResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool?
    let items: Repos?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
