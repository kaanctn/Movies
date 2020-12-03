//
//  Movie.swift
//  Movies
//
//  Created by Kaan Çetin  on 30.11.2020.
//

import Foundation

struct Movie: Codable {
    var originalTitle, posterPath: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var releaseDate, title: String?
    var popularity: Double?
    var adult: Bool?
    var backdropPath, overview: String?
    var genreIDS: [Int]?
    var id: Int?
    var originalLanguage: String?

    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case title, popularity, adult
        case backdropPath = "backdrop_path"
        case overview
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
    }
}
