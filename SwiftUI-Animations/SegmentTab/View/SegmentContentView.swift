//
//  SegmentContentView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI

struct SegmentContentView<Content: View>: View {
    let content: (Int) -> Content
    
    @EnvironmentObject var viewModel: SegmentTabViewModel
    
    init(@ViewBuilder _ content: @escaping (Int) -> Content) {
        self.content = content
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(0 ..< viewModel.titles.count, id: \.self) { index in
                content(index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.selectedIndex) { oldValue, newValue in
            guard newValue < viewModel.titles.count else { return }
            let item = viewModel.titles[newValue]
            viewModel.select(item)
        }
    }
}
