//
//  SegmentTab.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI

struct SegmentTab<Content: View>: View {
    let content: (Int) -> Content
    @Binding private var titles: [String]
    @Namespace var animationSpace
    @StateObject private var viewModel = SegmentTabViewModel()
    
    init(
        titles: Binding<[String]>,
        @ViewBuilder content: @escaping (Int) -> Content,
        viewModel: SegmentTabViewModel = SegmentTabViewModel()
    ) {
        self._titles = titles
        self.content = content
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        VStack(spacing: .zero) {
            SegmentTabbarView(animationSpace: animationSpace)
            SegmentContentView { index in
                content(index)
            }
        }
        .environmentObject(viewModel)
        .onChange(of: titles) { oldValue, newValue in
            viewModel.update(newValue)
        }
        .task {
            viewModel.update(titles)
        }
    }
}
