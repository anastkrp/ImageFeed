//
//  ImagesListViewTest.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 10.11.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTest: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        let presenterImagesList = ImagesListPresenterSpy()
        imagesListViewController.presenter = presenterImagesList
        presenterImagesList.view = imagesListViewController
        
        _ = imagesListViewController.view
        
        XCTAssertTrue(presenterImagesList.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateTableView() {
        let imagesListViewController = ImagesListControllerSpy()
        let presenterImagesList = ImagesListPresenterSpy()
        imagesListViewController.presenter = presenterImagesList
        presenterImagesList.view = imagesListViewController
        
        let testIndexPaths: [IndexPath] = [.init(row: 0, section: 0), .init(row: 1, section: 0)]
        
        imagesListViewController.updateTableView(indexPaths: testIndexPaths)
        
        XCTAssertTrue(imagesListViewController.updateTableViewCalled)
        XCTAssertEqual(imagesListViewController.indexPaths, testIndexPaths)
    }
    
    func testNextPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        let presenterImagesList = ImagesListPresenterSpy()
        imagesListViewController.presenter = presenterImagesList
        presenterImagesList.view = imagesListViewController
        
        let textIndexPath: IndexPath = .init(row: 10, section: 0)
        presenterImagesList.willDisplayCell(at: textIndexPath)
        
        XCTAssertTrue(presenterImagesList.nextPage)
        XCTAssertEqual(presenterImagesList.indexPath, textIndexPath)
    }
}
