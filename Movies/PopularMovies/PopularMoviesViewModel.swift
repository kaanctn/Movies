//
//  PopularMoviesViewModel.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

protocol PopularMoviesView: class {
    func onDataChanged()
    func onReloadIndexPaths(indexPaths: [IndexPath])
    func onError(error: Error)
    func onMovieDetails(movie: Movie)
    func onPersonDetails(person: Person)
}

class PopularMoviesViewModel {
    
    private weak var view: PopularMoviesView?
    private var movieService: MovieService
    private var genreService: GenreService
    private var discoverService: DiscoverService
    private var searchService: SearchService

    init(view: PopularMoviesView,
         movieService: MovieService = MovieServiceImpl(),
         genreService: GenreService = GenreServiceImpl(),
         discoverService: DiscoverService =  DiscoverServiceImpl(),
         searchService: SearchService = SearchServiceImpl()
    ) {
        self.view = view
        self.movieService = movieService
        self.genreService = genreService
        self.discoverService = discoverService
        self.searchService = searchService
    }
    
    enum Section: Equatable {
        
        case popularMovies, movieSearch, peopleSearch, discover
        
    }
    
    enum State {
        case loading, list, search, empty
    }
    
    private var disposeBag = DisposeBag()
    var state = BehaviorRelay<State>(value: .loading)
    
    private var sections = [Section.popularMovies, .movieSearch, .discover, .peopleSearch]
    private var genres: [Genre]?
    
    // MARK: - Popular Movies
    private var popularMoviesResult: APIResult<Movie>? {
        didSet {
            guard let newPage = popularMoviesResult?.results else { return }
            
            // Calculate indexes of new page
            let startIndex = popularMovies.count
            let endIndex = startIndex + newPage.count
            let newIndexes = Array(startIndex..<endIndex)
                .map({IndexPath(row: $0, section: 0)})
            
            // Append new page
            popularMovies.append(contentsOf: newPage)
            
            // Check if there is any movie
            if popularMovies.count > 0 {
                state.accept(.list)
            } else {
                state.accept(.empty)
            }
            
            // Check if we need reload certain indexes
            if startIndex == 0 {
                view?.onDataChanged()
            } else {
                view?.onReloadIndexPaths(indexPaths: newIndexes)
            }
        }
    }
    private var maxPrefetchRequestedRow = 0
    private var popularMovies = [Movie]()
    private var loadInProgress = false
    
    func loadPopularMovies() {
            
        if let results = popularMoviesResult, results.page ?? 0 >= results.totalPages ?? 0 || loadInProgress {
            return
        }
        loadInProgress = true
        movieService.getPopularMovies(page: (popularMoviesResult?.page ?? 0) + 1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (result) in
                self?.popularMoviesResult = result
                self?.loadInProgress = false
                self?.checkIfNeedMoreFetching()
            }, onError: { (error) in
                self.view?.onError(error: error)
            }).disposed(by: disposeBag)
    }
    
    func prefetchPopularMoviesAt(indexPaths: [IndexPath]) {
        if state.value != .list { return }
        self.maxPrefetchRequestedRow = indexPaths.map({$0.row}).max() ?? 0
        if maxPrefetchRequestedRow > self.popularMovies.count {
            loadPopularMovies()
        }
    }
    
    private func checkIfNeedMoreFetching() {
        if state.value != .list { return }
        if popularMovies.count < maxPrefetchRequestedRow {
            loadPopularMovies()
        }
    }
    
    // MARK: - Genre
    
    func loadGenres() {
        genreService.genres()
            .observeOn(MainScheduler.instance)
            .subscribe ( onNext: { (genres) in
                self.genres = genres
            }).disposed(by: disposeBag)
    }

    // MARK: - Search
    private var searchInProgress = false
    private var searchedMovies = [Movie]()
    private var searchedPeople = [Person]()
    private var discoveredMovies = [Movie]()
    
    
    private var searchDisposable: Disposable?
    
    func search(query: String) {
        
        if query.isEmpty {
            state.accept(.list)
            view?.onDataChanged()
            return
        }
            
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        state.accept(.loading)
        self.searchDisposable?.dispose()
        
        self.searchDisposable = Observable.zip(
            searchMovie(by: encodedQuery),
            searchPerson(by: encodedQuery),
            discoverMovies(by: query)) { [weak self] movieSearchResult, personSearchResult, movieDiscoverResult in
                        
            self?.state.accept(.search)
            self?.searchedMovies = movieSearchResult?.results ?? []
            self?.searchedPeople = personSearchResult?.results ?? []
            self?.discoveredMovies = movieDiscoverResult?.results ?? []
            if self?.searchedMovies.isEmpty ?? true
                && self?.searchedPeople.isEmpty ?? true
                && self?.discoveredMovies.isEmpty ?? true {
                self?.state.accept(.empty)
            }
            self?.view?.onDataChanged()
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onError: { (error) in
            self.view?.onError(error: error)
        })

        self.searchDisposable?.disposed(by: disposeBag)
    }
    
    private func searchMovie(by encodedQuery: String) -> Observable<APIResult<Movie>?> {
        return searchService.searchMovie(query: encodedQuery, page: 1)
            .map { result -> APIResult<Movie>? in
                return result
            }.catchErrorJustReturn(nil)
            .observeOn(MainScheduler.instance)
    }
    
    private func searchPerson(by encodedQuery: String) -> Observable<APIResult<Person>?> {
        return searchService.searchPerson(query: encodedQuery, page: 1)
            .map { result -> APIResult<Person>? in
                return result
            }.catchErrorJustReturn(nil)
            .observeOn(MainScheduler.instance)
    }
    
    private func discoverMovies(by query: String) -> Observable<APIResult<Movie>?> {
        guard let genreIds = findGenreIds(by: query) else {
            return Observable.just(nil)
        }
        if genreIds.isEmpty {
            return Observable.just(nil)
        }
        return discoverService.discoverMovies(genreIds: genreIds, page: 1)
            .map { result -> APIResult<Movie>? in
                return result
            }.catchErrorJustReturn(nil)
            .observeOn(MainScheduler.instance)
    }
    
    private func findGenreIds(by term: String) -> [Int]? {
        return genres?.filter({$0.name?.lowercased().contains(term.lowercased()) ?? false})
            .map({$0.id})
            .compactMap({$0})
    }
    
    // MARK: - Tableview
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .popularMovies:
            return state.value == .list ? popularMoviesResult?.totalResults ?? 0 : 0
        case .movieSearch:
            return state.value == .search ? searchedMovies.count : 0
        case .peopleSearch:
            return state.value == .search ? searchedPeople.count : 0
        case .discover:
            return state.value == .search ? discoveredMovies.count : 0
        }
    }
    
    func section(for index: Int) -> Section {
        return sections[index]
    }
    
    func personInfoTableViewCellViewModel(for row: Int, in section: Int) ->  PersonInfoTableViewCellViewModel? {
        switch sections[section] {
        case .peopleSearch:
            if searchedPeople.count > row {
                return PersonInfoTableViewCellViewModelImpl(with: searchedPeople[row])
            }
        default:
            fatalError()
        }
        return nil
    }
    
    func movieTableViewCellViewModel(for row: Int, in section: Int) -> MovieTableViewCellViewModel? {
        switch sections[section] {
        case .popularMovies:
            if popularMovies.count > row {
                return MovieTableViewCellViewModelImpl(movie: popularMovies[row])
            }
        case .movieSearch:
            if searchedMovies.count > row {
                return MovieTableViewCellViewModelImpl(movie: searchedMovies[row])
            }
        case .discover:
            if discoveredMovies.count > row {
                return MovieTableViewCellViewModelImpl(movie: discoveredMovies[row])
            }
        default:
            fatalError()
        }
        return nil
    }
        
    func headerTitle(for section: Int) -> String? {
        let section = sections[section]
        switch section {
        case .popularMovies:
            return state.value == .list ? "Popular Movies" : nil
        case .movieSearch:
            return state.value == .search && !searchedMovies.isEmpty ? "Movies" : nil
        case .peopleSearch:
            return state.value == .search && !searchedPeople.isEmpty ? "People" : nil
        case .discover:
            return state.value == .search && !discoveredMovies.isEmpty ? "Discover" : nil
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .popularMovies:
            if indexPath.row < popularMovies.count {
                view?.onMovieDetails(movie: popularMovies[indexPath.row])
            }
        case .movieSearch:
            view?.onMovieDetails(movie: searchedMovies[indexPath.row])
        case .discover:
            view?.onMovieDetails(movie: discoveredMovies[indexPath.row])
        case .peopleSearch:
            view?.onPersonDetails(person: searchedPeople[indexPath.row])
        }
    }
}
