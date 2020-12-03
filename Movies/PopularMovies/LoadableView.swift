//
//  UIView.swift
//  Movies
//
//  Created by Kaan Çetin  on 4.12.2020.
//

import UIKit

protocol LoadableView {
    func startLoading()
    func endLoading()
}

extension UIView: LoadableView {
    
    func startLoading() {
        var view: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            view = UIActivityIndicatorView(style: .medium)
        } else {
            view = UIActivityIndicatorView(style: .gray)
        }
        view.layer.zPosition = 999
        view.tag = 999
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        view.center = view.center
    }
    
    func endLoading() {
        if let view = self.viewWithTag(999) {
            view.removeFromSuperview()
        }
    }
}

