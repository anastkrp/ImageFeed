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
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, photos name: [Photo], _ table: UITableView) {
        let imageName = name[indexPath.row]
        
        guard let urlImage = URL(string: imageName.thumbImageURL) else {
            print("[configCell] Ошибка: Некорректный URL")
            return
        }
        
        cell.likeButton.imageView?.image = UIImage(named: imageName.isLiked ? "Active" : "No_Active")
        cell.dateLabel.text = ImagesListService.shared.dateToString(imageName.createdAt)
        
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
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let imageName = isLiked ? "No_Active" : "Active"
        likeButton.imageView?.image = UIImage(named: imageName)
    }
}
