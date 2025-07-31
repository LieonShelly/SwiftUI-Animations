//
//  FeedContentView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI

struct FeedContentView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTabIndex) {
            ForEach(0 ..< viewModel.topics.count, id: \.self) { index in
                let topic = viewModel.topics[index]
                PostsFeedView(topic: topic)
                    .tag(index)
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.selectedTabIndex) { oldValue, newValue in
            if newValue < viewModel.topics.count {
                let topic = viewModel.topics[newValue]
                viewModel.select(topic)
            }
        }
    }
}
