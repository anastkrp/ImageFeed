//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 22.09.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private let tokenStorage = OAuth2TokenStorage()
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard var urlComponents = URLComponents(string: Constants.tokenUrl) else {
            print("Ошибка - urlComponents")
            fatalError("Ошибка urlComponents")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("Ошибка - url")
            fatalError("Ошибка url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = response.accessToken
                    print("Получен токен - \(response.accessToken)")
                    completion(.success(response.accessToken))
                } catch {
                    print("Ошибка декодирования - \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Ошибка сети - \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
