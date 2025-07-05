//
//  PagingSegmentView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/5.
//

import SwiftUI

struct PagingSegmentView: View {
    private let titles = ["Home", "Explore", "Profile"]
    @State private var selectedIndex = 0
    @State private var offsetX: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            // Segment
            SegmentSelector(titles: titles, selectedIndex: $selectedIndex, offsetX: $offsetX)

            // Pager Content
            GeometryReader { geo in
                let width = geo.size.width
                TabView(selection: $selectedIndex) {
                    ForEach(0..<titles.count, id: \.self) { i in
                        ColorView(index: i)
                            .tag(i)
                            .frame(width: width)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: OffsetKey.self, value: proxy.frame(in: .global).minX)
                                }
                            )
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onPreferenceChange(OffsetKey.self) { value in
                    // 计算当前滑动偏移（相对于屏幕宽度）
                    let screenWidth = UIScreen.main.bounds.width
                    let rawOffset = -value / screenWidth
                    self.offsetX = rawOffset
                }
            }
        }
    }
}

struct SegmentSelector: View {
    let titles: [String]
    @Binding var selectedIndex: Int
    @Binding var offsetX: CGFloat

    var body: some View {
        GeometryReader { geo in
            let buttonWidth = geo.size.width / CGFloat(titles.count)
            
            ZStack(alignment: .bottomLeading) {
                HStack(spacing: 0) {
                    ForEach(titles.indices, id: \.self) { i in
                        Button {
                            withAnimation {
                                selectedIndex = i
                            }
                        } label: {
                            Text(titles[i])
                                .foregroundColor(selectedIndex == i ? .blue : .gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }

                // Indicator
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: buttonWidth, height: 2)
                    .offset(x: buttonWidth * offsetX)
            }
        }
        .frame(height: 44)
    }
}

struct ColorView: View {
    let index: Int
    let colors: [Color] = [.red, .green, .yellow]
    
    var body: some View {
        colors[index % colors.count]
            .overlay(Text("Page \(index)").font(.largeTitle).foregroundColor(.white))
    }
}

// 用于追踪页面偏移
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
