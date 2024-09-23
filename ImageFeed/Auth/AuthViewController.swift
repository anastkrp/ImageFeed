//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 20.09.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let showWebViewIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewIdentifier {
            guard let webViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(showWebViewIdentifier)")
            }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchOAuthToken(code) { result in
            switch result {
            case .success(let token):
                print("Получен токен - \(token)")
            case .failure(let error):
                print("Ошибка получения токена - \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
