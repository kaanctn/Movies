//
//  MovieDetail.swift
//  Movies
//
//  Created by Kaan Çetin  on 30.11.2020.
//

import Foundation

struct MovieDetail: Codable {
    var adult: Bool?
    var backdropPath: String?
    //var belongsToCollection: JSONNull?
    var budget: Int?
    var genres: [Genre]?
    var homepage: String?
    var id: Int?
    var imdbID, originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath: String?
    //var productionCompanies, productionCountries: [JSONAny]?
    var releaseDate: String?
    var revenue, runtime: Int?
    //var spokenLanguages: [String]?
    var status, tagline, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        //case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        //case productionCompanies = "production_companies"
        //case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        //case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
