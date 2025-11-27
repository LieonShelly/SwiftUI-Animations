//
//  CustomPagedView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/11/27.
//

import SwiftUI

enum DragStatus {
    case inactive
    case dragging(translation: CGFloat, isHorizontal: Bool)
    
    var translation: CGFloat {
        switch self {
        case .inactive:
            return 0
        case let .dragging(translation, isHorizontal):
            return isHorizontal ? translation : 0
        }
    }
    
    var isHorizontakDragging: Bool {
        switch self {
        case .inactive: return false
        case let .dragging(_, isHorizontal): return isHorizontal
        }
    }
}

struct PageView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    @ViewBuilder let content: Content
    @GestureState private var dragStatus: DragStatus = .inactive
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            HStack(spacing: 0) {
                content
                    .frame(width: width)
                    .allowsTightening(!dragStatus.isHorizontakDragging)
            }
            .frame(width: width * CGFloat(pageCount), alignment: .leading)
            .offset(x: -CGFloat(currentIndex) * width + currentOffset(width: width))
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: dragStatus.translation)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: currentIndex)
            .simultaneousGesture(
                DragGesture()
                    .updating($dragStatus) { value, state, _ in
                        let isHorizontal = abs(value.translation.width) > abs(value.translation.height)
                        state = .dragging(translation: value.translation.width, isHorizontal: isHorizontal)
                    }
                    .onEnded { value in
                        let isHorizontalDrag = abs(value.translation.width) > abs(value.translation.height)
                        if isHorizontalDrag {
                            let offset = value.translation.width
                            let threshold = width * 0.2
                            if offset < -threshold || value.predictedEndLocation.x < -threshold {
                                if currentIndex < pageCount - 1 {
                                    currentIndex += 1
                                }
                            } else if offset > threshold || value.predictedEndLocation.x > threshold {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                }
                            }
                        }
                    }
            )
        }
        .clipped()
    }
    
    private func currentOffset(width: CGFloat) -> CGFloat {
        let translation = dragStatus.translation
        if currentIndex == 0 && dragStatus.translation > 0 {
            return translation / 3
        } else if currentIndex == pageCount - 1 && translation < 0 {
            return translation / 3
        }
        return translation
    }
}
