//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 10.11.2024.
//

import Foundation
import UIKit

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func willDisplayCell(at indexPath: IndexPath)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init() {
        imagesListObserver()
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row + 1 == view?.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    private func imagesListObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateImages()
            }
    }
    
    private func updateImages() {
        let oldCount = view?.photos.count ?? 0
        let newCount = imagesListService.photos.count
        view?.photos = imagesListService.photos
        
        if oldCount != newCount {
            var indexPaths: [IndexPath] = []
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            view?.updateTableView(indexPaths: indexPaths)
        }
    }
}
