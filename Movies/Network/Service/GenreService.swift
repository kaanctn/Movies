//
//  GenreService.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation
import RxSwift

protocol GenreService {
    func genres() -> Observable<[Genre]>
}

class GenreServiceImpl: TMDBService, GenreService {
    
    func genres() -> Observable<[Genre]> {
        guard let request = GenreAPI.genres.asURLRequest() else {
            fatalError()
        }
        let obserable: Observable<Genres> = send(request: request, with: client)
        return obserable.map({$0.genres ?? []})
    }
}
