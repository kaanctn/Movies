//
//  DiscoverAPI.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation

enum DiscoverAPI {
    
    case movie(genreIds: [Int], page: Int)
    
    var method: String {
        return "GET"
    }
    
    var url: String {
        switch self {
        case .movie(genreIds: let genreIds, page: let page):
            let temp = genreIds.map({String($0)}).joined(separator: ",")
            return "/discover/movie?with_genres=\(temp)&api_key=\(APIConstants.apiKey)&page=\(page)"
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
