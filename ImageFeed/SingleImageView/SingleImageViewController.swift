//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 07.09.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var imageURL: URL?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let imageURL else {
            return
        }
        
        let share = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    private func loadImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.imageView.frame.size = imageResult.image.size
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так.",
                                      message: "Попробовать ещё раз?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
            self?.loadImage()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let newContentSize = scrollView.contentSize
        let visibleRectSize = scrollView.bounds.size
        let top = (visibleRectSize.height - newContentSize.height) / 2
        let left = (visibleRectSize.width - newContentSize.width) / 2
        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: 0, right: 0)
    }
}
