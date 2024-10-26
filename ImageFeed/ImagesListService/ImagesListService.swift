//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 24.10.2024.
//

import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    private let tokenStorage = OAuth2TokenStorage()
    private let defaultBaseURL = "https://api.unsplash.com"
    
    private let session = URLSession.shared
    private var loading = false
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private enum ImageListServiceError: Error {
        case invalidRequest
    }
    
    private init() {}
    
    func fetchPhotosNextPage() {
        
        guard !loading else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        loading = true
        
        guard let url = URL(string: "\(defaultBaseURL)/photos?page=\(nextPage)") else {
            print("[fetchPhotosNextPage]: Ошибка url")
            return
        }
        
        guard let token = tokenStorage.token else {
            print("[fetchPhotosNextPage]: Ошибка получения токена")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode([PhotoResult].self, from: data)
                    
                    DispatchQueue.main.async {
                        var newPhotos: [Photo] = []
                        
                        for object in response {
                            let photo = Photo(id: object.id,
                                              size: CGSize(width: object.width, height: object.height),
                                              createdAt: self.dateFromSrting(object.createdAt),
                                              welcomeDescription: object.description,
                                              thumbImageURL: object.imageURL.thumb,
                                              largeImageURL: object.imageURL.full,
                                              isLiked: object.isLiked)
                            newPhotos.append(photo)
                        }
                        
                        self.photos.append(contentsOf: newPhotos)
                        self.lastLoadedPage = nextPage
                        self.loading = false
                        
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: nil
                        )
                    }
                } catch {
                    print("[fetchPhotosNextPage]: Ошибка декодирования")
                }
            case .failure(let error):
                print("[fetchPhotosNextPage]: Ошибка сети \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(defaultBaseURL)/photos/\(photoId)/like") else {
            print("[changeLike]: Ошибка url")
            completion(.failure(ImageListServiceError.invalidRequest))
            return
        }
        
        guard let token = tokenStorage.token else {
            print("[changeLike]: Ошибка получения токена")
            completion(.failure(ImageListServiceError.invalidRequest))
            return
        }
        
        let httpMethod = isLike ? "DELETE" : "POST"
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: !photo.isLiked)
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                    }
                }
                print("[changeLike]: Изменение лайка успешно")
                completion(.success(()))
            case .failure(let error):
                print("[changeLike]: Ошибка сети \(error.localizedDescription)")
                completion(.failure(ImageListServiceError.invalidRequest))
            }
        }
        task.resume()
    }
    
    private func dateFromSrting(_ string: String?) -> Date? {
        guard let string else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.date(from: string)
    }
}
