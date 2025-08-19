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
            ImagePreview()
        }
    }
}

struct ImagePreview: View {
    @GestureState private var drag: CGSize = .zero
    @State private var offset: CGSize = .zero
    @GestureState private var manualZoom: Double = 1.0
    @State private var zoom: Double = 1
    @State private var zoomed: Bool = false
    @State private var zoomAnchor: UnitPoint = .center
    
    var body: some View {
        GeometryReader { proxy in
            let imageHorizontalPadding: CGFloat = 8
            let imageWidth = proxy.size.width - imageHorizontalPadding * 2
            let imageHeight: CGFloat =  imageWidth * 252 / 375
            let viewport = CGSize(width: imageWidth, height: imageHeight)
            
            ZStack {
                Color.white
                VStack {
                    VStack {
                        Image(.invoice)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            
                    }
                    
                    .frame(width: viewport.width, height: viewport.height)
                    .clipped()
                    .scaleEffect(zoom * manualZoom, anchor: zoomAnchor)
                    .offset(zoomed ? offset + drag : .zero)
                  
                }
          
            }
            .animation(.easeInOut, value: offset)
            .animation(.easeInOut, value: drag)
            .animation(.easeInOut, value: zoom)
            .animation(.easeInOut, value: zoomAnchor)
            .animation(.easeInOut, value: zoomed)
            .animation(.easeInOut, value: manualZoom)
            .simultaneousGesture(DragGesture()
                .updating($drag) { currentState, gestureState, transaction in
                    if zoomed {
                        gestureState = currentState.translation
                    }
                }
                .onEnded { value in
                    guard zoomed else { return }
                    let proposed = offset + value.translation
                    offset = clampOffset(proposed,
                                         viewport: viewport,
                                         scale: zoom)
                }
            )
            .simultaneousGesture(MagnifyGesture()
                .updating($manualZoom) { currentState, gestureState, transcation in
                    gestureState = currentState.magnification
                }
                .onEnded {
                    let newZoom = zoom * $0.magnification
                    zoom = min(max(newZoom, 1), 2)
                    zoomed = zoom > 1.0
                })
            .onTapGesture(count: 2) { tap in
                if zoomed {
                    zoomAnchor = .center
                    zoom = 1
                    offset = .zero
                    zoomed = false
                } else {
                    zoomAnchor = UnitPoint(x: tap.x / (proxy.size.width - imageHorizontalPadding * 2), y: tap.y / proxy.size.height)
                    zoom = 1.25
                    offset = .zero
                    zoomed = true
                }
            }
        }
        
    }
    
    
    private func clampOffset(_ offset: CGSize,
                             viewport: CGSize,
                             scale: CGFloat) -> CGSize {
        let scaledWidth = viewport.width * scale
        let scaledHeight = viewport.height * scale
        
        let maxX = max((scaledWidth - viewport.width) / 2, 0)
        let maxY = max((scaledHeight - viewport.height) / 2, 0)
        
        let clampedX = min(max(offset.width, -maxX), maxX)
        let clampedY = min(max(offset.height, -maxY), maxY)
        
        return CGSize(width: clampedX, height: clampedY)
    }

}


#Preview {
    ImagePreview()
}
