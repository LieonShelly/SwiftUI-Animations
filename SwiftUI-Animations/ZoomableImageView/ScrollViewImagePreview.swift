//
//  ScrollViewImagePreview.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/8/21.
//


import SwiftUI
import UIKit

struct ZoomableImageSwiftUIView: UIViewRepresentable {
    let image: UIImage
    
    func makeUIView(context: Context) -> ZoomableImageView {
        return ZoomableImageView(image: image)
    }
    
    func updateUIView(_ uiView: ZoomableImageView, context: Context) {
        uiView.updateImage(image)
    }
    
}

struct ScrollViewImagePreview: UIViewControllerRepresentable {
    let image: UIImage
    
    func makeUIViewController(context: Context) -> ImagePreviewViewControllerGpt {
        let viewController = ImagePreviewViewControllerGpt()
//        viewController.image = image
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ImagePreviewViewControllerGpt, context: Context) {
//        uiViewController.image = image
    }
}

class ImagePreviewViewController: UIViewController, UIScrollViewDelegate {
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
        }
    }
    private lazy var scrollView  = {
       let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = minZoom
        scrollView.maximumZoomScale = maxZoom
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.bouncesZoom = true
        scrollView.backgroundColor = .red
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var imageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageViewContainer = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    private lazy var debugView = {
       let view = UIView()
        view.backgroundColor = .red.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var imageHeight = imageView.heightAnchor.constraint(equalToConstant: 0)
    
    private let maxZoom: CGFloat = 4.0
    private let minZoom: CGFloat = 1.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }
    
    
    private func setupUI() {

        view.addSubview(scrollView)
        scrollView.addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
        view.addSubview(debugView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            imageViewContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageViewContainer.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageViewContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageViewContainer.widthAnchor, constant: -16),
       
        ])
        if let image {
            let imageWidth = view.bounds.width - 16
            let imageAspect = image.size.height  / image.size.width
            let imageH = imageWidth * imageAspect
            self.imageHeight.constant = imageH
            self.imageHeight.isActive = true
            scrollView.contentSize = CGSize(width: imageWidth, height: 0)
        }
    }
    
    private func setupGestures() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }

    
    private func centerContent() {
        let contentSize = scrollView.contentSize
        let scrollViewSize = scrollView.bounds.size
        let horizontalInset = max(0, (scrollViewSize.width - contentSize.width) / 2)
        let verticalInset = max(0, (scrollViewSize.height - contentSize.height) / 2)
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewContainer
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setCenteredContentInset()
    }

    func setCenteredContentInset() {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)

        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > minZoom {
            scrollView.setZoomScale(minZoom, animated: true)
        } else {
            let location = gesture.location(in: gesture.view)
            let zoomScale = maxZoom / 2
            let scrollViewSize = scrollView.bounds.size
            let rectWidth = scrollViewSize.width / zoomScale
            let rectHeight = scrollViewSize.height / zoomScale
            let rect = CGRect(
                x: location.x - rectWidth / 2,
                y: location.y - rectHeight / 2,
                width: rectWidth,
                height: rectHeight
            )
            debugView.frame = rect
            scrollView.zoom(to: rect, animated: true)
        }
    }
}
