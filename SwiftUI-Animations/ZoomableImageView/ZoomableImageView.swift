//
//  MediaViewProtocol.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/8/22.
//

import UIKit


final class ZoomableImageView: UIView {
    var image: UIImage

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addGestureRecognizer(doubleTapGesture)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    private lazy var doubleTapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        return tapGesture
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var contentTopConstraint: NSLayoutConstraint = {
        scrollView.topAnchor.constraint(equalTo: topAnchor)
    }()

    private lazy var contentLeadingConstraint: NSLayoutConstraint = {
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
    }()
    
    private lazy var contentTrailingConstraint: NSLayoutConstraint = {
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
    }()

    private lazy var contentBottomConstraint: NSLayoutConstraint = {
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
    }()

    private lazy var imageViewXCenter: NSLayoutConstraint = {
        imageView.centerXAnchor.constraint(
            equalTo: centerXAnchor)
    }()
    
    private lazy var imageViewYCenter: NSLayoutConstraint = {
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    }()

    private lazy var contentAspectRatioConstraint: NSLayoutConstraint = {
        imageView.widthAnchor.constraint(
            equalTo: self.imageView.heightAnchor,
            multiplier: image.size.width / image.size.height)
    }()

    private lazy var contentFullWidthConstraint: NSLayoutConstraint = {
        imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -16)
    }()

    
    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        setupSubviews()
    }
    

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage(_ image: UIImage) {
        self.image = image
        self.imageView.image = image
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
            guard let self else { return }
            NSLayoutConstraint.deactivate([
                imageViewXCenter,
                imageViewYCenter,
            ])
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentFullWidthConstraint,
                contentAspectRatioConstraint,
            ])
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.setCenteredContentInset()
        })
    }
}

private extension ZoomableImageView {
    @objc
    func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard scrollView.zoomScale <= 1.0 else {
            scrollView.setZoomScale(1, animated: true)
            return
        }

        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        let targetRect = CGRect(x: location.x - (imageView.frame.size.width / 4),
                                y: location.y - (imageView.frame.size.height / 4),
                                width: imageView.frame.size.width / 2,
                                height: imageView.frame.size.height / 2)
        scrollView.zoom(to: targetRect,
                        animated: true)
    }

    func setupSubviews() {
        
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            contentTopConstraint,
            contentLeadingConstraint,
            contentTrailingConstraint,
            contentBottomConstraint,
            
            imageViewXCenter,
            imageViewYCenter,
            contentFullWidthConstraint,
            contentAspectRatioConstraint
        ])
    }
}

extension ZoomableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setCenteredContentInset()
    }

    func setCenteredContentInset() {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)

        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}

public extension UIView {
    
    func addFullFillingSubView(_ subView: UIView) {
        addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: topAnchor),
            subView.bottomAnchor.constraint(equalTo: bottomAnchor),
            subView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
