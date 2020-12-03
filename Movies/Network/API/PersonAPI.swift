//
//  PersonAPI.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import Foundation

enum PersonAPI {
    
    case combinedCredits(personId: Int)
    case details(personId: Int)
    
    var method: String {
        return "GET"
    }
    
    var url: String {
        switch self {
        case .combinedCredits(personId: let personId):
            return "/person/\(personId)/combined_credits?language=\(locale)&api_key=\(APIConstants.apiKey)"
        case .details(personId: let personId):
            return "/person/\(personId)?language=\(locale)&api_key=\(APIConstants.apiKey)"
        }
    }
    
    var locale: String {
        Locale.current.languageCode ?? "en_US"
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
