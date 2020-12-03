//
//  ImageAPI.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation

enum ImageAPI {
            
    case poster(width: Int, posterPath: String)
    
    var method: String {
        return "GET"
    }
    
    var url: String {
        switch self {
        case .poster(width: let width, posterPath: let path):
            return "/w\(width)/\(path)"
        }
    }
    
    func asURLRequest() -> URLRequest? {
        
        guard let apiURL = URL(string: APIConstants.imageHost + url) else {
            return nil
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = method
        return request
    }
}
