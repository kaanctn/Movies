//
//  SimpleClient.swift
//  MovieListing
//
//  Created by Kaan Çetin  on 11.07.2020.
//

import Foundation
import RxSwift
import RxCocoa

protocol HttpClient {
    func send(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
}

public class SimpleClient: HttpClient {
    
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func send(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return self.session.rx.response(request: request)
    }
}
