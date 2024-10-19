//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 14.10.2024.


import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    private let tokenStorage = OAuth2TokenStorage()
    private let defaultBaseURL = "https://api.unsplash.com"
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private let session = URLSession.shared
    
    private init() {}
    
    private enum ProfileServiceError: Error {
        case invalidRequest
    }
    
    private func makeProfileRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: defaultBaseURL) else {
            print("[makeProfileRequest]: Ошибка urlComponents")
            assertionFailure("Ошибка urlComponents")
            return nil
        }
        
        urlComponents.path = "/me"
        
        guard let url = urlComponents.url else {
            print("[makeProfileRequest]: Ошибка url")
            fatalError("Ошибка url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(code)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastToken != token {
                task?.cancel()
            } else {
                completion(.failure(ProfileServiceError.invalidRequest))
                return
            }
        } else {
            if lastToken == token {
                completion(.failure(ProfileServiceError.invalidRequest))
                return
            }
        }
        
        lastToken = token
        
        guard let token = tokenStorage.token else {
            print("[fetchProfile]: Ошибка получения токена")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        guard let request = makeProfileRequest(code: token) else {
            print("[fetchProfile]: Ошибка создания запроса")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let profileResult):
                let name = "\(profileResult.firstName ?? "")" + " " + "\(profileResult.lastName ?? "")"
                let loginName = "@\(profileResult.username)"
                
                let profile = Profile(username: profileResult.username, name: name, loginName: loginName, bio: profileResult.bio ?? "")
                
                self.profile = profile
                
                print("[fetchProfile]: Профиль получен")
                completion(.success(profile))
            case .failure(let error):
                print("[fetchProfile] Ошибка сети \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastToken = nil
        }
        self.task = task
        task.resume()
    }
}
