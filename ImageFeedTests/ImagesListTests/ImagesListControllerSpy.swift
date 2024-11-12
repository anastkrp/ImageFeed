//
//  ImagesListControllerSpy.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 12.11.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    var indexPaths: [IndexPath] = []
    var updateTableViewCalled: Bool = false
    
    var photos: [ImageFeed.Photo] = []
    
    func updateTableView(indexPaths: [IndexPath]) {
        updateTableViewCalled = true
        self.indexPaths = indexPaths
    }
}
