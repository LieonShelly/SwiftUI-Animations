//
//  SwiftUI_AnimationsApp.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/24.
//

import SwiftUI

@main
struct SwiftUI_AnimationsApp: App {
    var body: some Scene {
        WindowGroup {
            ImagePreviewExample()
        }
    }
}

struct ImagePreviewExample: View {
    var body: some View {
        NavigationStack {
            VStack {
                ZoomableImageSwiftUIView(image: UIImage(resource: .invoice))
                bottomView
            }
            .navigationTitle("电子发票")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    var bottomView: some View {
        VStack(spacing: .zero) {
            Divider()
            
            HStack {
                Rectangle().frame(height: 40)
                Rectangle().frame(height: 40)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
        }
        .background(.white)
        
    }
}

struct ImagePreview: View {
    @State private var offset: CGSize = .zero
    @State private var zoom: Double = 1
    @State private var zoomed: Bool = false
    @State private var zoomAnchor: UnitPoint = .center
    @State private var pinchScale: CGFloat = 1
    private let maxZoom: CGFloat = 4
    private let minZoom: CGFloat = 1
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.red
                imageView(proxy)
                gestureView(proxy)
            }
            .onTapGesture(count: 2) { tap in
                if zoomed {
                    zoomAnchor = .center
                    zoom = minZoom
                    offset = .zero
                    zoomed = false
                } else {
                    let imageFrame = calculateImageFrame(proxy)
                    zoomAnchor = UnitPoint(
                        x: max(0, min(1, (tap.x - imageFrame.minX) / imageFrame.width)),
                        y: max(0, min(1, (tap.y - imageFrame.minY) / imageFrame.height))
                    )
                    zoom = maxZoom / 2
                    offset = .zero
                    zoomed = true
                }
            }
        }
    }
    
    private func imageView(_ proxy: GeometryProxy) -> some View {
        VStack {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: imageSize(proxy).width, height: imageSize(proxy).height)
            .clipped()
           
        }
        .scaleEffect(zoom * pinchScale, anchor: zoomAnchor)
        .offset(offset)
        .animation(.easeInOut, value: offset)
        .animation(.easeInOut, value: pinchScale)
        .animation(.easeInOut, value: zoom)
        .animation(.easeInOut, value: zoomAnchor)
        .animation(.easeInOut, value: zoomed)
    }
    
    private func gestureView(_ proxy: GeometryProxy) -> some View {
        PinchBridge { type, deltaScale, translation, centerDelta, absoluteCenter, state in
            let imageFrame = calculateImageFrame(proxy)
            if type == .pan {
                switch state {
                case .began:
                    break
                case .changed:
                    offset.width  += translation.x
                    offset.height += translation.y
                case .ended, .cancelled, .failed:
                    offset = clampOffset(offset, viewport: viewport(proxy), imageSize: imageSize(proxy), scale: zoom, anchor: zoomAnchor)
                }
            } else {
                switch state {
                case .began:
                    pinchScale = 1
                    zoomAnchor = UnitPoint(
                        x: (absoluteCenter.x - imageFrame.minX) / imageFrame.width,
                        y: (absoluteCenter.y - imageFrame.minY) / imageFrame.height
                    )
                case .changed:
                    pinchScale *= deltaScale
                    let newAnchor = UnitPoint(
                        x: (absoluteCenter.x - imageFrame.minX) / imageFrame.width,
                        y: (absoluteCenter.y - imageFrame.minY) / imageFrame.height
                    )
                    // 调整偏移以保持缩放中心
                    let oldScaledPoint = CGPoint(
                        x: imageFrame.width * zoomAnchor.x * (zoom * pinchScale),
                        y: imageFrame.height * zoomAnchor.y * (zoom * pinchScale)
                    )
                    let newScaledPoint = CGPoint(
                        x: imageFrame.width * newAnchor.x * (zoom * pinchScale),
                        y: imageFrame.height * newAnchor.y * (zoom * pinchScale)
                    )
                    offset.width += (-oldScaledPoint.x + newScaledPoint.x) / (zoom * pinchScale)
                    offset.height += (-oldScaledPoint.y + newScaledPoint.y) / (zoom * pinchScale)
                    zoomAnchor = newAnchor
                case .ended, .cancelled, .failed:
                    zoom = min(max(zoom * pinchScale, minZoom), maxZoom)
                    pinchScale = 1
                    offset = clampOffset(offset, viewport: viewport(proxy), imageSize: imageSize(proxy), scale: zoom, anchor: zoomAnchor)
                }
            }
        }
    }
    
    private func viewport(_ proxy: GeometryProxy) -> CGSize {
        let viewport = imageSize(proxy)
        return viewport
    }
    
    private func calculateImageFrame(_ proxy: GeometryProxy) -> CGRect {
        let size = imageSize(proxy)
        let imageHorizontalPadding: CGFloat = 8
        let x = imageHorizontalPadding
        let y = (proxy.size.height - size.height) / 2
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    
    private func imageSize(_ proxy: GeometryProxy) -> CGSize {
        let imageHorizontalPadding: CGFloat = 8
        let imageWidth = proxy.size.width - imageHorizontalPadding * 2
        let aspectRatio = image.size.height / image.size.width
        let imageHeight: CGFloat = imageWidth * aspectRatio
        let viewport = CGSize(width: imageWidth, height: imageHeight)
        return viewport
    }
    
    private func clampOffset(_ offset: CGSize,
                             viewport: CGSize,
                             imageSize: CGSize,
                             scale: CGFloat,
                             anchor: UnitPoint) -> CGSize {
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        
        var clampedX = offset.width
        var clampedY = offset.height
        
        // 计算缩放后图片的边界，考虑 zoomAnchor
        let anchorOffsetX = imageSize.width * scale * anchor.x
        let anchorOffsetY = imageSize.height * scale * anchor.y
        
        // X 轴边界
        if scaledWidth > viewport.width {
            // 左边缘贴合：图片左边缘 (x = -anchorOffsetX) 位于视口 x = 0
            let minOffsetX = -anchorOffsetX
            // 右边缘贴合：图片右边缘 (x = scaledWidth - anchorOffsetX) 位于视口 x = viewport.width
            let maxOffsetX = scaledWidth - viewport.width - anchorOffsetX
            
            // 限制 offset 在范围内
            clampedX = min(max(offset.width, minOffsetX), maxOffsetX)
            
            // 回弹到最近的边界
            if abs(offset.width - minOffsetX) < abs(offset.width - maxOffsetX) {
                clampedX = minOffsetX // 贴合左边缘
            } else {
                clampedX = maxOffsetX // 贴合右边缘
            }
        } else {
            clampedX = (viewport.width - scaledWidth) / 2 // 居中
        }
        
        // Y 轴边界
        if scaledHeight > viewport.height {
            // 上边缘贴合：图片上边缘 (y = -anchorOffsetY) 位于视口 y = 0
            let minOffsetY = -anchorOffsetY
            // 下边缘贴合：图片下边缘 (y = scaledHeight - anchorOffsetY) 位于视口 y = viewport.height
            let maxOffsetY = scaledHeight - viewport.height - anchorOffsetY
            
            // 限制 offset 在范围内
            clampedY = min(max(offset.height, minOffsetY), maxOffsetY)
            
            // 回弹到最近的边界
            if abs(offset.height - minOffsetY) < abs(offset.height - maxOffsetY) {
                clampedY = minOffsetY // 贴合上边缘
            } else {
                clampedY = maxOffsetY // 贴合下边缘
            }
        } else {
            clampedY = (viewport.height - scaledHeight) / 2 // 居中
        }
        
        return CGSize(width: clampedX, height: clampedY)
    }
    
}

private struct PinchBridge: UIViewRepresentable {
    enum GestureType {
        case pinch
        case pan
    }
    
    enum State { case began, changed, ended, cancelled, failed }
    
    let onUpdate: (_ type: GestureType,
                   _ deltaScale: CGFloat,
                   _ translation: CGPoint,
                   _ centerDelta: CGPoint,
                   _ absoluteCenter: CGPoint,
                   _ state: State) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.purple.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = true
        
        let pinch = UIPinchGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePinch(_:))
        )
        pinch.delegate = context.coordinator
        view.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: context.coordinator,
                                         action: #selector(Coordinator.handlePan(_:)))
        pan.maximumNumberOfTouches = 2
        pan.delegate = context.coordinator
        view.addGestureRecognizer(pan)
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onUpdate: onUpdate)
    }
    
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let onUpdate: (_ type: GestureType,
                       _ deltaScale: CGFloat,
                       _ translation: CGPoint,
                       _ centerDelta: CGPoint,
                       _ absoluteCenter: CGPoint,
                       _ state: State) -> Void
        
        
        private var lastScale: CGFloat = 1
        private var lastCenter: CGPoint = .zero
        private var began = false
        
        
        init(onUpdate: @escaping (_ type: GestureType,
                                  _ deltaScale: CGFloat,
                                  _ translation: CGPoint,
                                  _ centerDelta: CGPoint,
                                  _ absoluteCenter: CGPoint,
                                  _ state: State) -> Void) {
            self.onUpdate = onUpdate
        }
        
        @objc func handlePinch(_ gr: UIPinchGestureRecognizer) {
            guard let view = gr.view else { return }
            let center = gr.location(in: view)
            
            switch gr.state {
            case .began:
                lastScale = 1
                lastCenter = center
                onUpdate(.pinch, 1, .zero, .zero, center, .began)
                
            case .changed:
                let deltaScale = (lastScale == 0) ? 1 : (gr.scale / lastScale)
                let deltaCenter = CGPoint(x: center.x - lastCenter.x, y: center.y - lastCenter.y)
                onUpdate(.pinch, deltaScale, .zero, deltaCenter, center, .changed)
                
                lastScale = gr.scale
                lastCenter = center
                
            case .ended:
                onUpdate(.pinch, 1, .zero, .zero, center, .ended)
                
            case .cancelled:
                onUpdate(.pinch, 1, .zero, .zero, center, .cancelled)
                
            case .failed:
                onUpdate(.pinch, 1, .zero, .zero, center, .failed)
                
            default:
                break
            }
        }
        
        @objc func handlePan(_ gr: UIPanGestureRecognizer) {
            let translation = gr.translation(in: gr.view)
            
            switch gr.state {
            case .began:
                onUpdate(.pan, 1, translation, .zero, .zero, .began)
                
            case .changed:
                onUpdate(.pan, 1, translation, .zero, .zero, .changed)
                gr.setTranslation(.zero, in: gr.view)
                
            case .ended:
                onUpdate(.pan, 1, .zero, .zero, .zero, .ended)
                
            case .cancelled:
                onUpdate(.pan, 1, .zero, .zero, .zero, .cancelled)
                
            case .failed:
                onUpdate(.pan, 1, .zero, .zero, .zero, .failed)
                
            default:
                break
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            true
        }
    }
}

