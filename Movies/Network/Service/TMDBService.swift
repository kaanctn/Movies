//
//  TMDBService.swift
//  Movies
//
//  Created by Kaan Çetin  on 3.12.2020.
//

import Foundation
import RxSwift

class TMDBService {
    
    var client: HttpClient
    
    init(client: HttpClient =  SimpleClient()) {
        self.client = client
    }
}

extension TMDBService {
    
    func send<R: Codable>(request: URLRequest, with client: HttpClient) -> Observable<R> {
        return client.send(request: request)
            .asObservable()
            .map({ (response, data) -> R in
                switch response.statusCode {
                case 200:
                    return try JSONDecoder().decode(R.self, from: data)
                case 400, 401:
                    let error = try JSONDecoder().decode(APIError.self, from: data)
                    throw error
                default:
                    throw APIError(statusMessage: "Received unexpected response code", statusCode: response.statusCode)
                }
            })
    }
}
