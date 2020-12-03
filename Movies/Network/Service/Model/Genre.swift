//
//  Genre.swift
//  Movies
//
//  Created by Kaan Çetin  on 30.11.2020.
//

import Foundation

struct Genres: Codable {
    var genres: [Genre]?
}

struct Genre: Codable {
    var id: Int?
    var name: String?
}
