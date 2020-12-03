//
//  Video.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import Foundation

struct Video: Codable {
    var id, iso639_1, iso3166_1, key: String?
    var name, site: String?
    var size: Int?
    var type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key, name, site, size, type
    }
}
