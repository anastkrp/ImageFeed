//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 08.11.2024.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func loadAvatar()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init() {
        profileObserve()
    }
    
    func viewDidLoad() {
        loadProfileData()
        loadAvatar()
    }
    
    func loadProfileData() {
        if let profile = profileService.profile {
            view?.updateProfileDetails(name: profile.name, login: profile.loginName, description: profile.bio)
        } else {
            print("Ошибка: Профиль не найден")
        }
    }
    
    private func profileObserve() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.loadAvatar()
            }
    }
    
    func loadAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(url: url)
    }
}
