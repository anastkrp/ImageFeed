//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 15.10.2024.
//

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    
    private let tokenStorage = OAuth2TokenStorage()
    private let defaultBaseURL = "https://api.unsplash.com"
    
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    private let session = URLSession.shared
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    private enum ProfileImageError: Error {
        case invalidRequest
    }
    
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: defaultBaseURL) else {
            print("[makeProfileImageRequest]: Ошибка urlComponents")
            assertionFailure("Ошибка urlComponents")
            return nil
        }
        
        urlComponents.path = "/users/\(username)"
        
        guard let url = urlComponents.url else {
            print("[makeProfileImageRequest]: Ошибка url")
            fatalError("Ошибка url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastUsername != username {
                task?.cancel()
            } else {
                completion(.failure(ProfileImageError.invalidRequest))
                return
            }
        } else {
            if lastUsername == username {
                completion(.failure(ProfileImageError.invalidRequest))
                return
            }
        }
        
        lastUsername = username
        
        guard let token = tokenStorage.token else {
            print("[fetchProfileImageURL]: Ошибка получения токена")
            completion(.failure(ProfileImageError.invalidRequest))
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            print("[fetchProfileImageURL]: Ошибка создания запроса")
            completion(.failure(ProfileImageError.invalidRequest))
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                if let avatar = data.profileImage.small {
                    self.avatarURL = avatar
                    
                    completion(.success(avatar))
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatar])
                    
                } else {
                    print("[fetchProfileImageURL]: Изображение пользователя \(username) не загружено")
                    completion(.failure(ProfileImageError.invalidRequest))
                }
            case .failure(let error):
                print("[fetchProfileImageURL]: Ошибка сети \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
