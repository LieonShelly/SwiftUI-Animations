//
//  SegmentTabbarView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI

struct SegmentTabbarView: View {
    @EnvironmentObject var viewModel: SegmentTabViewModel
    var animationSpace: Namespace.ID
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(0 ..< viewModel.titles.count, id: \.self) { index in
                        let title = viewModel.titles[index]
                        SegmentTabbarItemView(
                            title: title,
                            isActive: viewModel.isSelectedItem(title),
                            animationSpace: animationSpace,
                            onSelect: {
                                viewModel.select(title)
                            }
                        )
                        .id(title.id)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .onChange(of: viewModel.selectedItem) { oldValue, newValue in
                guard let newValue else { return }
                withAnimation {
                    scrollProxy.scrollTo(newValue.id, anchor: .center)
                }
            }
        }
        
    }
}

import SwiftUI

struct SegmentTabbarItemView: View {
    let title: SegmentTabData
    let isActive: Bool
    var highlightColor: Color = .purple
    var animationSpace: Namespace.ID
    var onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: .zero) {
            Text(title.title)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .frame(height: 50)
        .contentShape(.rect)
        .onTapGesture {
            guard !isActive else { return }
            onSelect()
        }
        .overlay(alignment: .bottom) {
            if isActive {
                highlightColor
                    .frame(height: 2)
                    .matchedGeometryEffect(id: "tabitem", in: animationSpace)
            }
        }
    }
}
