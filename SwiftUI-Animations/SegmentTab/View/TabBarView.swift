//
//  TabBarView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Namespace private var animation
    
    var body: some View {
        ScrollViewReader { scrollproxy in
            ScrollView(.horizontal) {
                HStack(spacing: 24) {
                    ForEach(viewModel.topics, id: \.id) { topic in
                        TabBarItemView(
                            topic: topic,
                            isActive: viewModel.isTopicSelected(topic),
                            animationNameSpace: animation,
                            height: viewModel.topicsBarHeight
                        ) {
                            viewModel.select(topic)
                        }
                        .id(topic.id)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .onChange(of: viewModel.selectedTopic) { oldValue, newValue in
                guard let topic = newValue else { return }
                withAnimation {
                    scrollproxy.scrollTo(topic.id, anchor: .center)
                }
            }
        }
    }
}
