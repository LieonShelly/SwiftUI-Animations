//
//  PostsFeedView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/7/30.
//

import SwiftUI

struct PostsFeedView: View {
    let topic: Topic
    private let topicsBarHeight: CGFloat = 30
    private let navigationBarHeight: CGFloat = 44
    private let headerPadding: CGFloat = 12
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if let posts = topic.posts {
                    ForEach(posts) { post in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: topic.color))
                            .frame(height: 200)
                            .padding(.horizontal, 16)
                            .overlay {
                                Text(post.content)
                                    .padding()
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                    }
                }
            }
        }
        .contentMargins(.vertical, navigationBarHeight + topicsBarHeight + headerPadding + 10)
    }
}
