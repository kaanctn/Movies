//
//  SearchAPI.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation

enum SearchAPI {
    
    case movie(query: String, page: Int)
    case person(query: String, page: Int)
    
    var method: String {
        return "GET"
    }
    
    var url: String {
        switch self {
        case .movie(query: let query, page: let page):
            return "/search/movie?query=\(query)&api_key=\(APIConstants.apiKey)&page=\(page)"
        case .person(query: let query, page: let page):
            return "/search/person?query=\(query)&api_key=\(APIConstants.apiKey)&page=\(page)"
        }
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
