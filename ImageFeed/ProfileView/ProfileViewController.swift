//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 06.09.2024.
//

import UIKit

final class ProfileViewController: UIViewController {

    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypBlack
        
        createAvatar()
        createLabels()
        createButton()
    }
    
    private func createAvatar() {
        let image = UIImageView(image: UIImage(named: "Photo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        avatarImageView = image
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 70),
            image.widthAnchor.constraint(equalToConstant: 70),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func createLabels() {
        let name = UILabel()
        name.configureLabel(text: "Екатерина Новикова",
                            textColor: .ypWhite,
                            font: UIFont.boldSystemFont(ofSize: 23),
                            view: view)
        nameLabel = name
        
        let loginName = UILabel()
        loginName.configureLabel(text: "@ekaterina_nov",
                                 textColor: .ypGray,
                                 font: UIFont.systemFont(ofSize: 13),
                                 view: view)
        loginNameLabel = loginName
        
        let description = UILabel()
        description.configureLabel(text: "Hello, world!",
                                   textColor: .ypWhite,
                                   font: UIFont.systemFont(ofSize: 13),
                                   view: view)
        descriptionLabel = description
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: avatarImageView!.bottomAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            loginName.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            loginName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            description.topAnchor.constraint(equalTo: loginName.bottomAnchor, constant: 8),
            description.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            description.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }
    
    private func createButton() {
        let button = UIButton.systemButton(with: UIImage(named: "Exit")!,
                                           target: self,
                                           action: #selector(self.didTapLogoutButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        logoutButton = button
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 24),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: avatarImageView!.centerYAnchor)
        ])
    }
    
    @objc private func didTapLogoutButton(){
        
    }
}
