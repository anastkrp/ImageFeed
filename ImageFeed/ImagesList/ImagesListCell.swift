//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 03.09.2024.
//

import UIKit
import Kingfisher

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil // ? например, очистить какие-то приватные поля
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, photos name: [Photo], _ table: UITableView) {
        let imageName = name[indexPath.row]
        
        guard let urlImage = URL(string: imageName.thumbImageURL) else {
            print("[configCell] Ошибка: Некорректный URL")
            return
        }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: urlImage, placeholder: UIImage(named: "Stub.png")) { result in
            switch result {
            case .success:
                table.reloadRows(at: [indexPath], with: .automatic)
            case .failure:
                print("[configCell] Ошибка: Не удалось загрузить изображение")
                break
            }
        }
        cell.gradientView.addGradient()
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.imageView?.image = UIImage(named: "Active")
        } else {
            cell.likeButton.imageView?.image = UIImage(named: "No_Active")
        }
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
    }
}
