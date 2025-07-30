//
//  TabBarItemView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

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
