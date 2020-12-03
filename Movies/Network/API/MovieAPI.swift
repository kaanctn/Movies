//
//  MovieAPI.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation

enum MovieAPI {
    
    case popular(page: Int)
    case movieDetails(movieId: Int)
    case credits(movieId: Int)
    
    var method: String {
        return "GET"
    }
    
    var url: String {
        switch self {
        case .popular(page: let page):
            return "/movie/popular?language=\(locale)&api_key=\(APIConstants.apiKey)&page=\(page)"
        case .movieDetails(movieId: let movieId):
            return "/movie/\(movieId)?language=\(locale)&api_key=\(APIConstants.apiKey)"
        case .credits(movieId: let movieId):
            return "/movie/\(movieId)/credits?language=\(locale)&api_key=\(APIConstants.apiKey)"
        }
    }
    
    var locale: String {
        Locale.current.languageCode ?? "en_US" // TODO: Read from app locale provider
    }
    
    func asURLRequest() -> URLRequest? {
        
        guard let apiURL = URL(string: APIConstants.apiHost + url) else {
            return nil
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = method
        return request
    }
}
