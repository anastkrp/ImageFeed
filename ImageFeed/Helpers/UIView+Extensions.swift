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
    
    func animateGradeint(width: Double, height: Double) {
        let gradient = CAGradientLayer()
        
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        gradient.cornerRadius = bounds.height / 2
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        DispatchQueue.main.async {
            gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        }
    }
}
