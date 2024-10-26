//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 06.09.2024.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Photo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = (image.frame.size.height) / 2
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.configureLabel(text: "Екатерина Новикова",
                            textColor: .ypWhite,
                            font: UIFont.boldSystemFont(ofSize: 23),
                            view: view)
        return name
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let loginName = UILabel()
        loginName.configureLabel(text: "@ekaterina_nov",
                                 textColor: .ypGray,
                                 font: UIFont.systemFont(ofSize: 13),
                                 view: view)
        return loginName
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.configureLabel(text: "Hello, world!",
                                   textColor: .ypWhite,
                                   font: UIFont.systemFont(ofSize: 13),
                                   view: view)
        return description
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "Exit")!,
                                           target: self,
                                           action: #selector(self.didTapLogoutButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let storage = OAuth2TokenStorage()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypBlack
        createUI()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        } else {
            print("Ошибка: Профиль не найден")
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "UserpickStub.png"))
    }
    
    private func createUI() {
        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
    
    @objc private func didTapLogoutButton(){
        guard KeychainWrapper.standard.removeObject(forKey: "Auth token") else {
            return print("[didTapLogoutButton]: Не удалось удалить токен")
        }
        ProfileLogoutService.shared.logout()
    }
}
