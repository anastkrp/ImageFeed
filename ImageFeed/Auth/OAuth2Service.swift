//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 22.09.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let tokenStorage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private let session = URLSession.shared
    
    private init() {}
    
    enum AuthServiceError: Error {
        case invalidRequest
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.tokenUrl) else {
            print("[makeOAuthTokenRequest]: Ошибка urlComponents")
            assertionFailure("Ошибка urlComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("[makeOAuthTokenRequest]: Ошибка url")
            fatalError("Ошибка url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[fetchOAuthToken]: Ошибка создания запроса")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                self.tokenStorage.token = data.accessToken
                
                print("[fetchOAuthToken]: Токен получен")
                completion(.success(data.accessToken))
            case .failure(let error):
                print("[fetchOAuthToken]: Ошибка сети \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
}
