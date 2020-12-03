//
//  SearchService.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation
import RxSwift

protocol SearchService {
    func searchMovie(query: String, page: Int) -> Observable<APIResult<Movie>>
    func searchPerson(query: String, page: Int) -> Observable<APIResult<Person>>
}

class SearchServiceImpl: TMDBService, SearchService {
        
    func searchMovie(query: String, page: Int) -> Observable<APIResult<Movie>> {
        guard let request = SearchAPI.movie(query: query, page: page).asURLRequest() else {
            fatalError()
        }
        return send(request: request, with: client)
    }
    
    func searchPerson(query: String, page: Int) -> Observable<APIResult<Person>> {
        guard let request = SearchAPI.person(query: query, page: page).asURLRequest() else {
            fatalError()
        }
        return send(request: request, with: client)
    }
}
