//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 12.11.2024.
//

@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func loadAvatar() {
        
    }
}
