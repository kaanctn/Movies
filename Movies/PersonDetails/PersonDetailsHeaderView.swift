//
//  PersonDetailsHeaderView.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import UIKit

class PersonDetailsHeaderView: UIView {
        
    public lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        label.layer.zPosition = 1
        return label
    }()

    init() {
        super.init(frame: .zero)
        
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backdropImageView)
        addSubview(summaryLabel)
        addSubview(gradientView)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        NSLayoutConstraint.activate([
            backdropImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdropImageView.topAnchor.constraint(equalTo: topAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backdropImageView.widthAnchor.constraint(equalTo: backdropImageView.heightAnchor, multiplier: 16/9),
            
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            summaryLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 16),
            summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            summaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
