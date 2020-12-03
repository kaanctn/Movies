//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import UIKit
import RxSwift

class MovieTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    private lazy var vstackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 4
        return view
    }()
    
    public lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.darkText
        }
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        return label
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.darkText
        }
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                      
        addSubview(posterImageView)
        addSubview(vstackView)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: vstackView.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 90),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            vstackView.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            vstackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        vstackView.addArrangedSubview(titleLabel)
        vstackView.addArrangedSubview(subtitleLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with vm: MovieTableViewCellViewModel) {
        endLoading()
        titleLabel.text = vm.title
        subtitleLabel.text = vm.subtitle
        guard let posterPath = vm.posterPath else {
            return
        }
        vm.imageService.loadImage(width: 300, posterPath: posterPath)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [ weak self] image in
                self?.posterImageView.image = image
            }).disposed(by: disposeBag)
    }
    
    func configureAsLoading() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        posterImageView.image = nil
        startLoading()
    }
}

protocol MovieTableViewCellViewModel {
    var posterPath: String? { get }
    var title: String { get }
    var subtitle: String { get }
    var imageService: ImageService { get }
}

struct MovieTableViewCellViewModelImpl: MovieTableViewCellViewModel {
    
    var posterPath: String?
    var title: String
    var subtitle: String
    var imageService: ImageService
    
    init(credit: PersonCredit, imageService: ImageService = ImageServiceImpl()) {
        self.posterPath = credit.posterPath
        self.title = credit.title ?? "Untitled"
        self.subtitle = credit.character ?? ""
        self.imageService = imageService
    }
    
    init(movie: Movie, imageService: ImageService = ImageServiceImpl()) {
        self.posterPath = movie.posterPath
        self.title = movie.title ?? "Untitled"
        if let average = movie.voteAverage {
            self.subtitle = "\(average)"
        } else {
            self.subtitle = "Not Rated"
        }
        self.imageService = imageService
    }
}
