//
//  ImagePreviewViewController.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/8/22.
//


import UIKit

class ImagePreviewViewControllerGpt: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView(image: UIImage(resource: .invoice))
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
            
            setupScrollView()
            setupImageView()
            setupDoubleTapGesture()
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            updateZoomScaleAndCenter()
        }
        
        private func setupScrollView() {
            scrollView.frame = view.bounds
            scrollView.backgroundColor = .black
            scrollView.delegate = self
            scrollView.maximumZoomScale = 4.0
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = false
            scrollView.contentInsetAdjustmentBehavior = .never
            view.addSubview(scrollView)
        }
        
        private func setupImageView() {
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            scrollView.addSubview(imageView)
        }
        
        private func setupDoubleTapGesture() {
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTap.numberOfTapsRequired = 2
            scrollView.addGestureRecognizer(doubleTap)
        }
        
        private func updateZoomScaleAndCenter() {
            guard let image = imageView.image else { return }
            
            // 计算图片显示大小
            let scrollSize = scrollView.bounds.size
            let imageSize = image.size
            
            let widthScale = scrollSize.width / imageSize.width
            let heightScale = scrollSize.height / imageSize.height
            let minScale = min(widthScale, heightScale)
            
            scrollView.minimumZoomScale = minScale
            scrollView.zoomScale = minScale
            
            // 设置 imageView 尺寸
            let imageViewWidth = imageSize.width * minScale
            let imageViewHeight = imageSize.height * minScale
            imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
            
            scrollView.contentSize = imageView.bounds.size
            centerImage()
        }
        
        @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            let pointInView = gesture.location(in: imageView)
            
            if scrollView.zoomScale == scrollView.minimumZoomScale {
                let newZoomScale = scrollView.maximumZoomScale / 2
                let width = scrollView.bounds.size.width / newZoomScale
                let height = scrollView.bounds.size.height / newZoomScale
                let zoomRect = CGRect(x: pointInView.x - width / 2,
                                      y: pointInView.y - height / 2,
                                      width: width,
                                      height: height)
                scrollView.zoom(to: zoomRect, animated: true)
            } else {
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            }
        }
        
        // MARK: - UIScrollViewDelegate
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            centerImage()
        }
        
        private func centerImage() {
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                                       y: scrollView.contentSize.height * 0.5 + offsetY)
        }
}
