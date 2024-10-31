//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 26.10.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
