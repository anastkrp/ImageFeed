//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 03.09.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, photos name: [String]) {
        let imageName = name[indexPath.row]
        
        guard let image = UIImage(named: imageName) else {
            return
        }
        
        cell.cellImage.image = image
        cell.gradientView.addGradient()
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.imageView?.image = UIImage(named: "Active")
        } else {
            cell.likeButton.imageView?.image = UIImage(named: "No_Active")
        }
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
    }
}
