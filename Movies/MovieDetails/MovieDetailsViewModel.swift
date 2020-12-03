//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import Foundation
import RxSwift
import RxDataSources

class MovieDetailsViewModel {
    
    enum TableSection {
        case details, cast
    }
    
    enum TableItem {
        case movieDetail(model: MovieDetail), cast(model: Cast)
    }
    
    typealias Section = SectionModel<TableSection, TableItem>
    
    private var movie: Movie?
    private var personCredit: PersonCredit?
    
    private var movieService: MovieService
    private var imageService: ImageService
    private var disposeBag = DisposeBag()
        
    init(movie: Movie, movieService: MovieService, imageService: ImageService) {
        self.movie = movie
        self.movieService = movieService
        self.imageService = imageService
    }
    
    init(personCredit: PersonCredit, movieService: MovieService, imageService: ImageService) {
        self.personCredit = personCredit
        self.movieService = movieService
        self.imageService = imageService
    }
    
    var sections = PublishSubject<[Section]>()
    var error = PublishSubject<Error>()
    
    private var movieDetails: MovieDetail?
    private var cast: [Cast]?
    
    func loadMovieDetails() {
        
        guard let movieId = movie?.id ?? personCredit?.id else {
            return
        }
        
        Observable.zip(
            movieService.getMovieDetail(movieId: movieId),
            movieService.getCredits(movieId: movieId)
        ) { [weak self] details, credits in
            self?.movieDetails = details
            self?.cast = credits.cast ?? []
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            guard let details = self?.movieDetails, let cast = self?.cast else {
                return
            }
            let section1 = Section(model: .details, items: [.movieDetail(model: details)])
            let section2 = Section(model: .cast, items: cast.map({.cast(model: $0)}))
            self?.sections.onNext([section1, section2])
        }, onError: { [weak self] (error) in
            self?.error.onNext(error)
        })
        .disposed(by: disposeBag)
    }
}
