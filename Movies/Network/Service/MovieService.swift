//
//  MovieService.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieService {
    func getPopularMovies(page: Int) -> Observable<APIResult<Movie>>
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail>
    func getCredits(movieId: Int) -> Observable<Credit>
}

class MovieServiceImpl: TMDBService, MovieService {
        
    func getPopularMovies(page: Int) -> Observable<APIResult<Movie>> {
        guard let request = MovieAPI.popular(page: page).asURLRequest() else {
            fatalError()
        }
        return send(request: request, with: client)
    }
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        guard let request = MovieAPI.movieDetails(movieId: movieId).asURLRequest() else {
            fatalError()
        }
        return send(request: request, with: client)
    }
    
    func getCredits(movieId: Int) -> Observable<Credit> {
        guard let request = MovieAPI.credits(movieId: movieId).asURLRequest() else {
            fatalError()
        }
        return send(request: request, with: client)
    }
}
