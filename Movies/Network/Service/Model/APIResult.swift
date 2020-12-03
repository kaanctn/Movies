//
//  APIResulr.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation

struct APIResult<T: Codable>: Codable {
    var page: Int?
    var results: [T]?
    var totalResults, totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
