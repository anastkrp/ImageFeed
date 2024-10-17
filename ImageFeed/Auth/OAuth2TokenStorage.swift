//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 22.09.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "Auth token"
    
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: tokenKey)
            return token
        }
        set {
            guard let token = newValue else {
                return print("[OAuth2TokenStorage]: Токен не может быть nil")
            }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
            guard isSuccess else {
                return print("[OAuth2TokenStorage]: Ошибка сохранения токена")
            }
        }
    }
}
