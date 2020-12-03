//
//  DiscoverService.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation
import RxSwift

protocol DiscoverService {
    func discoverMovies(genreIds: [Int], page: Int) -> Observable<APIResult<Movie>>
}

class DiscoverServiceImpl: TMDBService, DiscoverService {
        
    func discoverMovies(genreIds: [Int], page: Int) -> Observable<APIResult<Movie>> {
        guard let request = DiscoverAPI.movie(genreIds: genreIds, page: page).asURLRequest() else {
            fatalError()
        }
        return send(request: request, with: client)
    }
}
