//
//  PersonService.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import Foundation
import RxSwift

protocol PersonService {
    func combinedCredits(personId: Int) -> Observable<PersonCreditsResult>
    func details(personId: Int) -> Observable<PersonDetails>
}

class PersonServiceImpl: TMDBService, PersonService {
    
    func combinedCredits(personId: Int) -> Observable<PersonCreditsResult> {
        guard let request = PersonAPI.combinedCredits(personId: personId).asURLRequest() else {
            fatalError()
        }
        return send(request: request, with: client)
    }
    
    func details(personId: Int) -> Observable<PersonDetails> {
        guard let request = PersonAPI.details(personId: personId).asURLRequest() else {
            fatalError()
        }
        return send(request: request, with: client)
    }
}
