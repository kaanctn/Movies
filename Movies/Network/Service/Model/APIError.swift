//
//  MovieAPIError.swift
//  MovieListing
//
//  Created by Kaan Çetin  on 11.07.2020.
//  Copyright © 2020 Kaan Çetin . All rights reserved.
//

import Foundation

struct APIError: Codable, Error, LocalizedError {
    
    var statusMessage: String?
    var success: Bool?
    var statusCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_mesage"
        case statusCode = "status_code"
    }
    
    var localizedDescription: String {
        return statusMessage ?? "Unknown error!"
    }
    
}
