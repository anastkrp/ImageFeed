//
//  UIView+Extensions.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 04.09.2024.
//

import UIKit

extension UIView {
    func addGradient() {
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.ypBlack.cgColor, UIColor.ypBlack.withAlphaComponent(0.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.8)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.frame = bounds
        gradientLayer.frame.size.width = bounds.width * 1.2
        
        if layer.sublayers?.count == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
