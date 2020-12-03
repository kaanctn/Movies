//
//  PosterService.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import Foundation
import RxSwift
import UIKit

enum ImageServiceError: Error, LocalizedError {
    case curruptedData
}

protocol ImageService {
    func loadImage(width: Int, posterPath: String) -> Observable<UIImage>
}

class ImageServiceImpl: TMDBService, ImageService {
    
    func loadImage(width: Int, posterPath: String) -> Observable<UIImage> {
        
        guard var request = ImageAPI.poster(width: width, posterPath: posterPath).asURLRequest() else {
            fatalError()
        }
        
        request.cachePolicy = .returnCacheDataElseLoad
                
        return client.send(request: request)
            .map({ (response, data) -> UIImage in
                guard let image = UIImage(data: data), response.statusCode == 200 else {
                    throw ImageServiceError.curruptedData
                }
                return image
            })
    }
}

