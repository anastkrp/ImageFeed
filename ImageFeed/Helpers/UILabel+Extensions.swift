//
//  UILabel+Extensions.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 11.09.2024.
//

import UIKit

extension UILabel {
    func configureLabel(text: String, textColor: UIColor, font: UIFont, view: UIView) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
    }
}
