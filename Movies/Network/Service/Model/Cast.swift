//
//  Cast.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import Foundation

struct Cast: Codable {
    var adult: Bool?
    var gender, id: Int?
    var knownForDepartment, name, originalName: String?
    var popularity: Double?
    var profilePath: String?
    var castID: Int?
    var character, creditID: String?
    var order: Int?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order
    }
}
