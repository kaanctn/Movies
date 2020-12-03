//
//  GenreAPI.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation

enum GenreAPI {
    
    case genres
    
    var method: String {
        return "GET"
    }
    
    var url: String {
        switch self {
        case .genres:
            return "/genre/movie/list?api_key=\(APIConstants.apiKey)"
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
