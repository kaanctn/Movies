//
//  Person.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation

struct Person: Codable {
    var profilePath: String?
    var adult: Bool?
    var id: Int?
    var knownFor: [Movie]?
    var name: String?
    var popularity: Double?

    enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path"
        case adult, id
        case knownFor = "known_for"
        case name, popularity
    }
}
