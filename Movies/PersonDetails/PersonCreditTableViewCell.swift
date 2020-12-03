//
//  PersonCreditTableViewCell.swift
//  Movies
//
//  Created by Kaan Çetin  on 3.12.2020.
//

import UIKit
import RxSwift

class PersonCreditTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    private lazy var vstackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 4
        return view
    }()
    
    public lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 50
        view.layer.masksToBounds = true
        return view
    }()

    public lazy var nameLabel: UILabel = {
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
    
    public lazy var birtdayLabel: UILabel = {
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
        selectionStyle = .none
        
        addSubview(profileImageView)
        addSubview(vstackView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            profileImageView.trailingAnchor.constraint(equalTo: vstackView.leadingAnchor, constant: -16),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            vstackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            vstackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        vstackView.addArrangedSubview(nameLabel)
        vstackView.addArrangedSubview(birtdayLabel)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with vm: PersonInfoTableViewCellViewModel) {
        nameLabel.text = vm.name
        guard let path = vm.profilePicPath else {
            return
        }
        vm.imageService.loadMoviePoster(width: 300, posterPath: path)
            .observeOn(MainScheduler.instance)
            .subscribe { [unowned self] (image) in
                self.profileImageView.image = image
            }
            .disposed(by: disposeBag)
    }
    
}
