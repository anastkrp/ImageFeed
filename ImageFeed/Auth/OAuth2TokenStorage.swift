//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 22.09.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    private let tokenKey = "tokenKey"
    
    var token: String? {
        get {
            return storage.string(forKey: tokenKey)
        }
        set {
            storage.set(newValue, forKey: tokenKey)
        }
    }
}
