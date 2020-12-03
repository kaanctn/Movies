//
//  MovieDetailsTableHeaderView.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import UIKit
import RxSwift

class MovieDetailsTableViewCell: UITableViewCell {
    
    private var disposeBag = DisposeBag()
    
    private lazy var vstack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 8
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        label.layer.zPosition = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(vstack)
        
        NSLayoutConstraint.activate([
            vstack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vstack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vstack.topAnchor.constraint(equalTo: topAnchor),
            vstack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            backdropImageView.widthAnchor.constraint(equalTo: backdropImageView.heightAnchor, multiplier: 16/9)
        ])
        
        vstack.addArrangedSubview(backdropImageView)
        vstack.addArrangedSubview(titleLabel)
        vstack.addArrangedSubview(overviewLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backdropImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with vm: MovieDetailsTableViewCellViewModel) {
        titleLabel.text = "\(vm.title) (\(vm.rating))"
        overviewLabel.text = vm.overview
        guard let path = vm.imagePath else {
            return
        }
        vm.imageService.loadImage(width: 1280, posterPath: path)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (image) in
                self?.backdropImageView.image = image
            }
            .disposed(by: disposeBag)
    }
}

protocol MovieDetailsTableViewCellViewModel {
    var imageService: ImageService { get }
    var imagePath: String? { get }
    var title: String { get }
    var rating: String { get }
    var overview: String? { get }
}

struct MovieDetailsTableViewCellViewModelImpl: MovieDetailsTableViewCellViewModel {
    
    var imageService: ImageService
    var imagePath: String?
    var title: String
    var rating: String
    var overview: String?
    
    init(movieDetail: MovieDetail, imageService: ImageService = ImageServiceImpl()) {
        self.imageService = imageService
        self.imagePath = movieDetail.backdropPath
        self.title = movieDetail.title ?? "Untitled"
        if let rating = movieDetail.voteAverage {
            self.rating = "\(rating)"
        } else {
            self.rating = "Not Rated"
        }
        self.overview = movieDetail.overview
    }
}
