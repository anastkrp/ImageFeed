//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 12.11.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var indexPath: IndexPath?
    var nextPage: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        nextPage = true
        self.indexPath = indexPath
    }
}
