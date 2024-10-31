//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 24.10.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let imageURL: UrlsResult
    let isLiked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case width = "width"
        case height = "height"
        case description = "description"
        case imageURL = "urls"
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}
