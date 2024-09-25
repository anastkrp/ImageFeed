//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 22.09.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
