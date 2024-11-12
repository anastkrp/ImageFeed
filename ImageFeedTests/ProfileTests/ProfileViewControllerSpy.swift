//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 12.11.2024.
//

@testable import ImageFeed
import Foundation

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
