//
//  ProfileViewTests.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 09.11.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let profileViewController = ProfileViewController()
        let presenterProfile = ProfileViewPresenterSpy()
        profileViewController.presenter = presenterProfile
        presenterProfile.view = profileViewController
        
        _ = profileViewController.view
        
        XCTAssertTrue(presenterProfile.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadAvatar() {
        let profileViewController = ProfileViewControllerSpy()
        let presenterProfile = ProfileViewPresenter()
        profileViewController.presenter = presenterProfile
        presenterProfile.view = profileViewController
        let url = URL(string: "https://unsplash.com/imageAvatar")!
        
        presenterProfile.viewDidLoad()
        profileViewController.updateAvatar(url: url)
        
        XCTAssertTrue(profileViewController.loadAvatarCalled)
        XCTAssertEqual(profileViewController.imageUrl, url)
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func loadAvatar() {
        
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol{
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var loadAvatarCalled: Bool = false
    var imageUrl: URL?
    
    func updateProfileDetails(name: String, login: String, description: String) {
        
    }
    
    func updateAvatar(url: URL) {
        loadAvatarCalled = true
        imageUrl = url
    }
}
