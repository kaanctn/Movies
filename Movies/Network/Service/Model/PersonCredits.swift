//
//  PersonCredit.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import Foundation

struct PersonCreditsResult: Codable {
    var cast, crew: [PersonCredit]?
    var id: Int?
}

struct PersonCredit: Codable {
    var id: Int?
    var originalLanguage: String?
    var episodeCount: Int?
    var overview: String?
    var originCountry: [String]?
    var originalName: String?
    var genreIDS: [Int]?
    var name: String?
    var mediaType: String?
    var posterPath: String?
    var firstAirDate: String?
    var voteAverage: Double?
    var voteCount: Int?
    var character: String?
    var backdropPath: String?
    var popularity: Double?
    var creditID, originalTitle: String?
    var video: Bool?
    var releaseDate, title: String?
    var adult: Bool?
    var department: String?
    var job: String?

    enum CodingKeys: String, CodingKey {
        case id
        case originalLanguage = "original_language"
        case episodeCount = "episode_count"
        case overview
        case originCountry = "origin_country"
        case originalName = "original_name"
        case genreIDS = "genre_ids"
        case name
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case backdropPath = "backdrop_path"
        case popularity
        case creditID = "credit_id"
        case originalTitle = "original_title"
        case video
        case releaseDate = "release_date"
        case title, adult, department, job
    }
}
