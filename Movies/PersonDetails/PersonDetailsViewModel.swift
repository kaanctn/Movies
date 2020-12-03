//
//  PersonDetailsViewModel.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import Foundation
import RxSwift

protocol PersonDetailsView: class {
    func onDataChanged()
    func onError(message: String)
    func onPersonCredit(credit: PersonCredit)
}

class PersonDetailsViewModel {
    
    enum TableSection {
        case profile, biography, cast(credits: [PersonCredit]), crew(credits: [PersonCredit])
    }
    
    private var disposeBag = DisposeBag()
    private var person: Person?
    private var cast: Cast?
    private var personDetails: PersonDetails?
    private var personService: PersonService
    private var sections = [TableSection]()
    
    weak var view: PersonDetailsView?
    
    init(person: Person, personService: PersonService, view: PersonDetailsView) {
        self.person = person
        self.personService = personService
        self.view = view
    }
    
    init(cast: Cast, personService: PersonService, view: PersonDetailsView) {
        self.cast = cast
        self.personService = personService
        self.view = view
    }
    
    func loadPersonDetails() {
        
        sections.append(.profile)
        view?.onDataChanged()
        
        let id = person?.id ?? cast?.id ?? 0
        Observable.zip(
            personService.combinedCredits(personId: id),
            personService.details(personId: id)
        ) { [weak self] credits, details in
            self?.personDetails = details
            self?.sections.append(.biography)
            if let cast = credits.cast {
                self?.sections.append(.cast(credits: cast))
            }
            if let crew = credits.crew {
                self?.sections.append(.crew(credits: crew))
            }
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            self?.view?.onDataChanged()
        }, onError: { [weak self] (error) in
            self?.view?.onError(message: error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .cast(credits: let credits):
            return credits.count
        case .crew(credits: let credits):
            return credits.count
        case .profile:
            return 1
        case .biography:
            return personDetails?.biography?.isEmpty ?? true ? 0 : 1
        }
    }
    
    func section(for index: Int) -> TableSection {
        return sections[index]
    }
    
    func personInfoTableViewCellViewModel() ->  PersonInfoTableViewCellViewModel {
        if let person = person {
            return PersonInfoTableViewCellViewModelImpl(with: person)
        }
        if let cast = cast {
            return PersonInfoTableViewCellViewModelImpl(with: cast)
        }
        fatalError()
    }
    
    func movieTableViewCellViewModel(for row: Int, in section: Int) -> MovieTableViewCellViewModel {
        switch sections[section] {
        case .cast(credits: let credits):
            return MovieTableViewCellViewModelImpl(credit: credits[row])
        default:
            fatalError()
        }
    }
    
    func personCreditCellViewModel(for row: Int, in section: Int) -> PersonCreditCellViewModel {
        switch sections[section] {
        case .crew(credits: let credits):
            return PersonCreditCellViewModelImpl(credit: credits[row])
        default:
            fatalError()
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .cast(let items):
            return items.count > 0 ? "Movies" : nil
        case .crew(let items):
            return items.count > 0 ? "Crew" : nil
        default:
            return nil
        }
    }
    
    func biography() -> String? {
        return personDetails?.biography
    }
    
    func didSelectItem(at row: Int, section: Int) {
        switch sections[section] {
        case .cast(credits: let items):
            let credit = items[row]
            self.view?.onPersonCredit(credit: credit)
        default:
            break
        }
    }
}

protocol PersonCreditCellViewModel {
    var title: String { get }
    var subtitle: String? { get }
}

struct PersonCreditCellViewModelImpl: PersonCreditCellViewModel {
    
    var title: String
    var subtitle: String?    
    
    init(credit: PersonCredit) {
        self.title = credit.title ?? "Untitled"
        self.subtitle = credit.character ?? credit.job
    }
}
