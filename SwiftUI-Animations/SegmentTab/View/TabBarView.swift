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

import SwiftUI

struct TabBarItemView: View {
    let topic: Topic
    let isActive: Bool
    var activeHighlightColor: Color = .purple
    let animationNameSpace: Namespace.ID
    let height: CGFloat
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: .zero) {
            Text(topic.name.capitalized)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isActive ? Color.primary : Color.gray)
            Spacer()
        }
        .frame(height: height)
        .overlay(alignment: .bottom) {
            if isActive {
                activeHighlightColor
                    .frame(height: 3)
                    .clipShape(.capsule)
                    .matchedGeometryEffect(id: "ACTIVE_TAV", in: animationNameSpace)
            }
        }
        .contentShape(.rect)
        .onTapGesture {
            guard !isActive else { return }
            onSelect()
        }
    }
}
