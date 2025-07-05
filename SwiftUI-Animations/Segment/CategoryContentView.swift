//
//  CategoryContentView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/4.
//

import SwiftUI

struct CategoryContentView: View {
    
    @Binding var totalProgress: CGFloat
    @State var scrollGeometry: ScrollGeometry = .init()
    @State var selectedIndex: Int = 0
    @State var segmentWidths: [Int: CGFloat] = [:]
    @State var segmentPositions: [Int: CGFloat] = [:]
    
    init(totalProgress: Binding<CGFloat>) {
        self._totalProgress = totalProgress
    }
    
    var body: some View {
        let progress = (scrollGeometry.offsetX / scrollGeometry.contentSize.width) / (1 / 10)
        GeometryReader { contianerProxy in
            VStack(spacing: .zero) {
                ScrollView(.horizontal) {
                    VStack(alignment: .leading) {
                        // segment
                        HStack(spacing: 20) {
                            ForEach(0 ..< 10) { index in
                                Text("Category:\(index)")
                                    .font(.body)
                                    .foregroundStyle(selectedIndex == index ? .blue : .black)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedIndex = index
                                        }
                                    }
                            }
                        }
                        .coordinateSpace(.named("segment"))
                        
                        // indicator
                        Capsule(style: .circular)
                            .foregroundStyle(.blue)
                            .frame(width: 30, height: 3)
                            .padding(.bottom, 10)
                    }
                    
                }
                .scrollIndicators(.hidden)
                
                // content
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: .zero) {
                        ForEach(0..<10) { index in
                            Rectangle()
                                .fill(.yellow)
                                .frame(width: contianerProxy.size.width, height: contianerProxy.size.height)
                                .overlay {
                                    Text("\(progress)")
                                }
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .onScrollGeometryChange(for: ScrollGeometry.self, of: { $0}, action: { newValue, _ in
                    scrollGeometry = newValue
                    
                    let totalOffset = scrollGeometry.contentOffset.x
                    let pageWidth = contianerProxy.size.width

                    // 当前页索引（向下取整）
                    let baseIndex = floor(totalOffset / pageWidth)

                    // 滑动进度（0 ~ 1）
                    let progress = (totalOffset / pageWidth) - baseIndex
                    
                    print(totalOffset / pageWidth)
                })
                .onScrollPhaseChange { oldPhase, newPhase in
                    print(newPhase)
                }
            }
            .padding()
        }
    }

}

extension ScrollGeometry {
    init() {
        self.init(contentOffset: .zero, contentSize: .zero, contentInsets: .init(.zero), containerSize: .zero)
    }
    
    var offsetY: CGFloat {
        contentOffset.y + contentInsets.top
    }
    
    var offsetX: CGFloat {
        contentOffset.x + contentInsets.leading
    }
}
