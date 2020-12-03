//
//  PersonDetails.swift
//  Movies
//
//  Created by Kaan Çetin  on 3.12.2020.
//

import Foundation

struct PersonDetails: Codable {
    var birthday, knownForDepartment: String?
    var deathday: String?
    var id: Int?
    var name: String?
    var alsoKnownAs: [String]?
    var gender: Int?
    var biography: String?
    var popularity: Double?
    var placeOfBirth, profilePath: String?
    var adult: Bool?
    var imdbID: String?
    var homepage: String?

    enum CodingKeys: String, CodingKey {
        case birthday
        case knownForDepartment = "known_for_department"
        case deathday, id, name
        case alsoKnownAs = "also_known_as"
        case gender, biography, popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbID = "imdb_id"
        case homepage
    }
}
